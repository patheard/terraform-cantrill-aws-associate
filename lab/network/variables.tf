variable "env" {
  type = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "subnet_ipv4_newbits" {
  description = "The number of bits to increase the VPC cidr block prefix by for each IPv4 subnet"
  type        = number
}

variable "subnet_ipv6_newbits" {
  description = "The number of bits to increase the VPC cidr block prefix by for each IPv6 subnet"
  type        = number
}

variable "subnets_public" {
  description = "The names of the public subnets.  These will be associated with the IGW route table"
  type        = set(string)
}

variable "subnets_public_prefix" {
  description = "The prefix portion of the subnets name (e.g. if public subnets are `sn-web-A`, `sn-web-B`, etc, then value is `sn-web`)"
  type        = string
}

variable "subnets" {
  description = "List of subnets to create"
  type = map(object({
    availability_zone  = string
    subnet_cidr_netnum = number
    public_internet    = bool
  }))
}

# Bastion host
variable "bastion_name" {
  description = "Name of the bastion host instance"
  type        = string
}

variable "bastion_ingress_ip" {
  description = "Ingress IP for the security group to allow SSH from"
  type        = string
}

variable "bastion_instance_type" {
  description = "Bastion host instance type"
  type        = string
}

variable "bastion_ssh_public_key" {
  description = "Public key for the bastion host"
  type        = string
}

variable "bastion_subnet_name" {
  description = "Subnet name to deploy the bastion host to"
  type        = string
}

variable "private_host_name" {
  description = "Name of the private host instance"
  type        = string
}

variable "private_host_subnet_name" {
  description = "Subnet name to deploy the private host to"
  type        = string
}
