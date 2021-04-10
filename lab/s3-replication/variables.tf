variable "bucket_name" {
  description = "Used for the source and destination replication buckets"
  type        = string
}

variable "env" {
  description = "The environment we're deploying into"
  type        = string
}
