output "public_ip" {
  value = module.ec2_stressed.public_ip
}

output "ssh_command" {
  value = "ssh -vvv ec2-user@${module.ec2_stressed.public_ip}"
}
