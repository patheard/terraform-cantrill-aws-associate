variable "env" {
  type = string
}

variable "instance_name" {
  description = "Name of the instance"
  type        = string
}

variable "instance_ingress_ip" {
  description = "Ingress IP for the security group to allow SSH from"
  type        = string
}

variable "instance_ssh_public_key" {
  description = "Public key for the instance"
  type        = string
}

variable "target_vpc_name" {
  description = "Name of the VPC to create the instance in"
  type        = string
}

variable "target_subnet_name" {
  description = "Name of the subnet to create the instance in"
  type        = string
}
