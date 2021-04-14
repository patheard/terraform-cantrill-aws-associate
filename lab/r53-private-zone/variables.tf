variable "domain_name" {
  description = "The domain name to create an A record for"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID attached to the private zone"
  type        = string
}
