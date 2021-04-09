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

#tfsec:ignore:AWS002    no logging needed for this demo
resource "aws_s3_bucket" "lifecycle_rules" {
  bucket = local.full_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    transition {
      days          = 360
      storage_class = "DEEP_ARCHIVE"
    }

    # Delete non-current versions
    noncurrent_version_expiration {
      days = 365
    }
  }
}
