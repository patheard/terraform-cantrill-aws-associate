output "vpc_arn" {
  value = aws_vpc.a4l_vpc1.arn
}

output "vpc_id" {
  value = aws_vpc.a4l_vpc1.id
}

output "subnets" {
  value = {
    for subnet, details in aws_subnet.subnet :
    subnet => ({
      "id"                = details.id
      "arn"               = details.arn
      "availability_zone" = details.availability_zone
      "cidr_block"        = details.cidr_block,
      "ipv6_cidr_block"   = details.ipv6_cidr_block
    })
  }
}

output "igw_id" {
  value = aws_internet_gateway.a4l_igw.id
}

output "bastion_id" {
  value = module.baston_host.id
}

output "bastion_public_ip" {
  value = module.baston_host.public_ip
}

output "bastion_private_ip" {
  value = module.baston_host.private_ip
}

output "bastion_ssh_command" {
  value = "ssh ec2-user@${module.baston_host.public_ip}"
}

output "private_host_id" {
  value = module.private_host.id
}

output "private_host_private_ip" {
  value = module.private_host.private_ip
}

output "private_host_ssh_command" {
  value = "ssh ec2-user@${module.private_host.private_ip}"
}
