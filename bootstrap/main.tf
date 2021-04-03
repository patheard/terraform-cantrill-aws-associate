terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Disable log enabled check on log bucket itself
#tfsec:ignore:AWS002
resource "aws_s3_bucket" "log_bucket" {
  bucket = "tfstate-logging"
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "storage_bucket" {
  bucket = var.storage_bucket

  acl = "private"
  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
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

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "pheard-associate-statelock"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
