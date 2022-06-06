
output "public_ip" {
  description = "public ip of the web server"
  value       = [aws_instance.web-server.public_ip]
}


output "public_WEB_server_name" {
  description = "public name of the web server"
  value       = [aws_instance.web-server.public_dns]
}

