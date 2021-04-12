# Jumpbox in the public web subnet
# Relies on IGW for inbound/outbound internet access
module "baston_host" {
  source = "../ec2"

  env            = var.env
  name           = var.bastion_name
  ingress_ip     = var.bastion_ingress_ip
  instance_type  = var.bastion_instance_type
  ssh_public_key = var.bastion_ssh_public_key

  vpc_id    = aws_vpc.a4l_vpc1.id
  subnet_id = aws_subnet.subnet[var.bastion_subnet_name].id
}

# Private host in a private subnet
# Relies on NAT gateway for outbound internet access
module "private_host" {
  source = "../ec2"

  env            = var.env
  name           = var.private_host_name
  ingress_ip     = aws_vpc.a4l_vpc1.cidr_block
  instance_type  = var.bastion_instance_type
  ssh_public_key = var.bastion_ssh_public_key

  vpc_id    = aws_vpc.a4l_vpc1.id
  subnet_id = aws_subnet.subnet[var.private_host_subnet_name].id
}
