variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database root username"
  type        = string
}

variable "db_password" {
  description = "Database root password"
  type        = string
}

variable "db_port" {
  description = "Database port to use"
  type        = number
}

variable "env" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "instance_ingress_ip" {
  type = string
}

variable "instance_ssh_public_key" {
  type = string
}

variable "instance_subnet_name" {
  type = string
}

variable "subnet_names_db" {
  description = "The database subnet names"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID to deploy the database to"
  type        = string
}
