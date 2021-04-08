variable "cloudtrail_name" {
  description = "The name of the CloudTrail"
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "The name of the CloudWatch log group"
  type        = string
}

variable "env" {
  description = "The environment the CloudTrail is being created in"
  type        = string
}
