variable "env" {
  type = string
}

variable "volume_name" {
  description = "Name of the volume to create"
  type        = string
}

variable "volume_device_name" {
  description = "The device name to present to the AWS instane"
  type        = string
  default     = "/dev/xvdh"
}

variable "volume_az" {
  description = "Availability zone to create the volume in"
  type        = string
}

variable "volume_size" {
  description = "Size of the volume in GB"
  type        = number
}

variable "volume_type" {
  description = "Type of volume to create. Defaults to gp3."
  type        = string
  default     = "gp3"
}

variable "volume_kms_key_id" {
  description = "KMS key ID to encrypt the volume with.  Defaults to the aws/ebs master key."
  type        = string
  default     = "aws/ebs"
}

variable "aws_instance_id" {
  description = "AWS instance ID to attach the volume to"
  type        = string
}

