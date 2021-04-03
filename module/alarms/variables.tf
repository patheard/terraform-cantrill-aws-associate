variable "env" {
  description = "Environment you are deploying to. Will be appended to SNS topic and alarm name. (e.g. dev, stage, prod)"
  type        = string
}

variable "monthly_billing_threshold" {
  description = "The threshold for which estimated monthly charges will trigger the metric alarm."
  type        = string
}

variable "currency" {
  description = "Short notation for currency type (e.g. USD, CAD, EUR)"
  type        = string
  default     = "CAD"
}

variable "email" {
  description = "Email address to subsribe to the SNS alarm topic"
  type        = string
}

variable "region" {
  description = "Region the alarm is deployed in"
  type        = string
}
