variable "aws_instance_id" {
  description = "AWS instance ID to attach the alarm to"
  type        = string
}

variable "alarm_action" {
  description = "Auto recovery action of the alarm.  Defaults to 'recover'"
  type        = string
  default     = "recover"
}
