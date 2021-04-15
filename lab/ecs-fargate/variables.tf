variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  type        = string
  default     = "acantril/containercat:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  type        = number
  default     = 80
}

variable "app_count" {
  description = "Number of docker containers to run"
  type        = number
  default     = 2
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "env" {
  description = "Environment the cluster is being deployed to"
  type        = string
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  type        = number
  default     = 512
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  type        = number
  default     = 1024
}

variable "subnet_names_private" {
  description = "List of private subnets associated with the ECS service"
  type        = list(string)
}

variable "subnet_names_public" {
  description = "List of public subnets to attach to the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC of the ECS cluster"
  type        = string
}
