output "id" {
  value = module.instance_profile_test.id
}

output "public_ip" {
  value = module.instance_profile_test.public_ip
}

output "private_ip" {
  value = module.instance_profile_test.private_ip
}

output "ssh_command" {
  value = "ssh ec2-user@${module.instance_profile_test.public_ip}"
}
