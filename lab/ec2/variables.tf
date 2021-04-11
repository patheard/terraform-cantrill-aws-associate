variable "env" {
  description = "Environment you are deploying to (appended to ec2 name)"
  type        = string
}

variable "name" {
  description = "Name of the ec2 instance"
  type        = string
}

variable "ingress_ip" {
  description = "IP address to allow for SSH ingress"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "ssh_public_key" {
  description = "Public key of the SSH key"
  type        = string
}

variable "user_data" {
  description = "User data script to run on instance start"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID for the instance's security group"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet for the instance's network interface card"
  type        = string
  default     = null
}
