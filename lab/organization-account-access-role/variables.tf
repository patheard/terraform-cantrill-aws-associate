variable "account_id" {
  description = "ID of the account to grant full access to"
  type        = string
}

variable "policy_arn" {
  description = "Managed policy ARN to attach"
  type        = string
  default     = "arn:aws:iam::aws:policy/AdministratorAccess"
}
