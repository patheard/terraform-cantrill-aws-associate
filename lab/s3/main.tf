locals {
  full_bucket_name = "${lower(var.bucket_name)}-${var.env}-${random_id.this.dec}"
}

resource "random_id" "this" {
  keepers = {
    # Generate a new id each time we switch the bucket name
    bucket_name = var.bucket_name
  }
  byte_length = 8
}

resource "aws_s3_bucket" "this" {
  bucket = local.full_bucket_name

  # required for the demo to allow bucket to log to itself
  acl = "log-delivery-write"
  versioning {
    enabled = true
  }

  force_destroy = true

  # Log to self
  logging {
    target_bucket = local.full_bucket_name # self.id doesn't work in this context ¯\_(ツ)_/¯
    target_prefix = "log/"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
