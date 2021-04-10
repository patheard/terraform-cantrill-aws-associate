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
resource "aws_s3_bucket" "replication_source" {
  bucket = "source-${local.full_bucket_name}"
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

  replication_configuration {
    role = aws_iam_role.replication_assume_role.arn

    rules {
      id     = "CopyAll"
      status = "Enabled"

      destination {
        bucket        = aws_s3_bucket.replication_destination.arn
        storage_class = "STANDARD"
      }
    }
  }
}

#tfsec:ignore:AWS002    no logging needed for this demo
resource "aws_s3_bucket" "replication_destination" {
  bucket = "destination-${local.full_bucket_name}"
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
}

resource "aws_iam_role" "replication_assume_role" {
  name = "s3-replication-assume-role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "s3.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_policy" "replication_policy" {
  name = "s3-replication-policy"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "s3:GetReplicationConfiguration",
          "s3:ListBucket",
        ],
        "Effect" : "Allow",
        "Resource" : [
          aws_s3_bucket.replication_source.arn
        ]
      },
      {
        "Action" : [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "${aws_s3_bucket.replication_source.arn}/*"
        ]
      },
      {
        "Action" : [
          "s3:ReplicateObject",
          "s3:ReplicateDelete"
        ],
        "Effect" : "Allow",
        "Resource" : "${aws_s3_bucket.replication_destination.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "replication_policy_attachment" {
  role       = aws_iam_role.replication_assume_role.name
  policy_arn = aws_iam_policy.replication_policy.arn
}
