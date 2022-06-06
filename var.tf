#-----------General---------------
variable "region" {
  type        = string
  description = "The AWS region."
  default     = "us-east-1"
}


variable "key-pair-public" {
  type        = string
  description = "The key pair public."
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/lNJEHVQr0N+/Xdf3l/9+88kJZsACDArPPnBY0op16OnXH15KfDJl4SKh8dvRL+3B2irl5HtE9siuHqVzX5FXDFBcZYS+W+1UQ45Wj6XeDBzGCJju0YcFIUJtUY9FDP5SKOqZBoyLJm9Xvw6Y/ZuspxqMdLHHIkI91s/pYNN59J1+XxDDuJTYzZVlhdT6RlOqetuzrOK12qiwsBiQiJVmzrZdtvjCCqFuAgRl56pz3xWz4t30NztK8/5mPt1EYJXFzdUuZwTp0jsPcFMfsABrnxZDHorDDBdDnydvbDr8F6XGxu6yMK65KjXHJZxSnwUpDfETPYceYMotcK5RY59OvZDCso0EYUJHkV05YQCGDSfbEoZMbu2GMBcGIjhPwfcGILez7QU1M4778c8MKDupaniA/COG/TjuVVb3uGV4qYyZYMZJWGjuBP5H9tSJKLoMMjajxAZ6ecux8kTBSPwmzCQAeYNJzE3+EIq3NqVX9jzolpRdNq2abXT5iu+hhhU= user@Galina-new-Asus"
}

variable "deployer-key" {
  type        = string
  description = "The KEY-pair name for EC2 connection"
  default = "deployer-key"
  }

variable "app-repo" {
  type        = string
  description = "The path to the repository in GitHub"
  default     = "https://github.com/GalinaKaz/app1-php.git"
}

#------------------VPC module and Security group variables--------------------------------

variable "vpcCIDRblock" {
  default = "10.0.0.0/16"
}
variable "private_subnet1" {
  default = "10.0.1.0/24"
}
variable "private_subnet2" {
  default = "10.0.2.0/24"
}

variable "public_subnet" {
  default = "10.0.0.0/24"
}

variable "ingressCIDRblock" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}

variable "sshToWebServer" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}


#-----------------------DATABASE configutation--------------------
 
variable "db-name" {
  default = "demodb"
}

variable "db-user" {
  default = "user"
}

variable "db-password" {
  default = "password"
}


