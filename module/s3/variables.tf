variable "env" {
  description = "Environment you are deploying to (appended to bucket name)"
  type        = string
}

variable "bucket_name" {
  description = "Surpisingly, this is the name of the bucket"
  type        = string
}
