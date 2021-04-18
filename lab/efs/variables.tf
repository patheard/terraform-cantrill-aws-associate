variable "efs_name" {
  description = "Name of the EFS to create"
  type        = string
}

variable "env" {
  description = "Name of the environment we're working in"
  type        = string
}

variable "efs_subnets" {
  description = "The list of subnet names to create a EFS mount target in"
  type        = list(string)
}

variable "instance_name" {
  description = "Name prefix for each instance"
  type        = string
}

variable "instance_ssh_public_key" {
  description = "SSH public key that will be added to each instance"
  type        = string
}

variable "subnets" {
  description = "The subnets output object from the network lab"
  type        = map(any)
}

variable "vpc_id" {
  description = "VPC to create the EFS in"
  type        = string
}
