
output "public_ip" {
  description = "public ip of the web server"
  value       = [aws_instance.web-server.public_ip]
}


output "public_WEB_server_name" {
  description = "public name of the web server"
  value       = [aws_instance.web-server.public_dns]
}

#---------------------additionals---------------------------


/*output "EndPoint" {
  description = "End Point to web Server"
  value       = [aws_db_instance.RdsForVpcProject.endpoint]
}

output "vpc_id" {
  description = "ID of project VPC"
  value       = module.vpc.vpc_id
}
output "name" {
  description = "name"
  value       = module.vpc.name
}

output "aws_db_subnet_group" {
  description = "db subnet name"
  value       = aws_db_subnet_group.for-database.name
}

output "private_subnets" {
  description = "private subnets"
  value       = [module.vpc.private_subnets]
}


output "public_subnets" {
  description = "public subnets"
  value       = flatten([module.vpc.public_subnets])
}
*/

