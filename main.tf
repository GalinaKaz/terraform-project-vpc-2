provider "aws" {

  region     = var.region
}

#---------------VPC-----------------------------
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = "project-vpc-terraform"
  cidr   = var.vpcCIDRblock

  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets = ["${var.private_subnet1}", "${var.private_subnet2}"]
  public_subnets  = ["${var.public_subnet}"]

  enable_nat_gateway = true
  single_nat_gateway = true
  
  enable_dns_hostnames = true
  enable_dns_support   = true


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


#---------------security groups------------------

# Create the Security Group for public WEB server
resource "aws_security_group" "secur-g-for-web" {
  vpc_id      = module.vpc.vpc_id
  name        = "secur-g-for-web"
  description = "Security Group for web server"

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.sshToWebServer
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # allow ingress of port 80
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "for-web"
    Description = "Security Group for web"
  }
} # end resource



# Create the Security Group for private DATABASE server
resource "aws_security_group" "secur-g-for-db" {
  vpc_id      = module.vpc.vpc_id
  name        = "secur-g-for-db"
  description = "Security Group for database in private subnet"

  # allow ingress of port 3306 - MySQL port
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }


  tags = {
    Name        = "for-db"
    Description = "Security Group for db"
  }
} # end resource

#--------------------RDS-----------------------------

# Create DB subnet group
resource "aws_db_subnet_group" "for-database" {
  name        = "db-group-name"
  description = "private subnets in different AZs"
  subnet_ids  = flatten([module.vpc.private_subnets])

  tags = {
    Name = "DB subnet group"
  }
}


resource "aws_db_instance" "RdsForVpcProject" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  db_name              = "${var.db-name}"
  username             = "${var.db-user}"
  password             = "${var.db-password}"
  db_subnet_group_name = aws_db_subnet_group.for-database.name
  vpc_security_group_ids = [aws_security_group.secur-g-for-db.id]
  skip_final_snapshot  = true
}


#------------------Web server-------------------

resource "aws_key_pair" "deployer" {
  key_name   = "${var.deployer-key}"
  public_key = "${var.key-pair-public}"
}

data "template_file" "init" {
  template = "${file("init.sh")}"
  vars = {
    end-point = "${aws_db_instance.RdsForVpcProject.endpoint}"
    user = "${var.db-user}"
    password = "${var.db-password}"
    db-name = "${var.db-name}"
    app-repo = "${var.app-repo}"
  }
}

# --------------Instance EC2 creation ----------------

resource "aws_instance" "web-server" {
  ami = "resolve:ssm:/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"  
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.secur-g-for-web.id]
  subnet_id = module.vpc.public_subnets[0]
  key_name = aws_key_pair.deployer.key_name
  user_data_base64  = base64encode(data.template_file.init.rendered)
  }



