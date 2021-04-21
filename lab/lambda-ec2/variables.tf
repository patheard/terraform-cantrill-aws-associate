variable "env" {
  description = "Name of the environment we're working in"
  type        = string
}

variable "lambda_functions" {
  description = "Filenames of the lambda functions that will be created"
  type        = set(string)
}

variable "subnets" {
  description = "The subnets output object from the network lab"
  type        = map(any)
}

variable "subnets_app" {
  description = "The names of the app subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC of the subnets the Lambda function will be attached to"
  type        = string
}

variable "vpc_cidr_block" {
  description = "IPv4 cidr block of the VPC"
  type        = string
}
