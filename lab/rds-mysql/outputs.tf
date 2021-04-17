output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.mysql.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.mysql.port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.mysql.username
}

output "instance_public_ip" {
  value = module.instance_test.public_ip
}

output "instance_private_ip" {
  value = module.instance_test.private_ip
}

output "instance_ssh_command" {
  value = "ssh ec2-user@${module.instance_test.public_ip}"
}
