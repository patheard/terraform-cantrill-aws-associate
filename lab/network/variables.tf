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

variable "subnets" {
  description = "List of subnets to create"
  type = map(object({
    availability_zone  = string
    subnet_cidr_netnum = number
  }))
}
