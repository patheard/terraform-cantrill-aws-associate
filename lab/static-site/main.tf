resource "aws_s3_bucket" "website" {
  bucket              = var.website_domain
  acl                 = "public-read" #tfsec:ignore:AWS001 public access is required
  force_destroy       = true
  acceleration_status = "Enabled"

  versioning {
    enabled = true
  }

  logging {
    target_bucket = aws_s3_bucket.website_logs.id
    target_prefix = "logs/"
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "website_logs" {
  bucket        = "${var.website_domain}-logs"
  acl           = "log-delivery-write"
  force_destroy = true

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "public_access" {
  bucket = aws_s3_bucket.website.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression's result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicAccess"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      },
    ]
  })
}

resource "aws_s3_bucket_object" "index" {
  bucket       = var.website_domain
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"

  # Triggers updates when the file contents change
  etag = filemd5("index.html")
}
