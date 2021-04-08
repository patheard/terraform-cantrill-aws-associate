data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  partition  = data.aws_partition.current.partition
  region     = data.aws_region.current.name
}

#tfsec:ignore:AWS065  do not use encryption for this example (saving money because of all the encryption requests)
resource "aws_cloudtrail" "root_org" {
  name                       = var.cloudtrail_name
  is_multi_region_trail      = true
  is_organization_trail      = true
  enable_logging             = true
  enable_log_file_validation = true

  s3_bucket_name = module.cloudtrail_s3.bucket_name
  s3_key_prefix  = "cloudtrail"

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudwatch_log_group.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cloudwatch_events_role.arn
}

module "cloudtrail_s3" {
  source = "../s3"

  bucket_name = "cloudtrail"
  env         = var.env
}

resource "aws_s3_bucket_policy" "allow_cloudtrail" {
  bucket = module.cloudtrail_s3.bucket_name
  policy = data.aws_iam_policy_document.cloudwatch_s3_policy.json
}

data "aws_iam_policy_document" "cloudwatch_s3_policy" {
  statement {
    sid    = "AWSCloudTrailAclCheck"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${module.cloudtrail_s3.bucket_name}"]
  }
  statement {
    sid    = "AWSCloudTrailWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${module.cloudtrail_s3.bucket_name}/cloudtrail/*"]

    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
  }
}

# Allow CloudWatch to consume CloudTrail events
resource "aws_iam_role" "cloudtrail_cloudwatch_events_role" {
  name_prefix        = "cloudtrail_events_role"
  path               = "/cloudtrail/"
  assume_role_policy = data.aws_iam_policy_document.cloudwatch_assume_policy.json
}

resource "aws_iam_role_policy" "cloudwatch_policy" {
  name_prefix = "cloudtrail_cloudwatch_events_policy"
  role        = aws_iam_role.cloudtrail_cloudwatch_events_role.id
  policy      = data.aws_iam_policy_document.cloudwatch_policy.json
}

data "aws_iam_policy_document" "cloudwatch_assume_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudwatch_policy" {
  statement {
    effect  = "Allow"
    actions = ["logs:CreateLogStream"]

    resources = [
      "arn:${local.partition}:logs:${local.region}:${local.account_id}:log-group:${aws_cloudwatch_log_group.cloudwatch_log_group.name}:log-stream:*",
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["logs:PutLogEvents"]

    resources = [
      "arn:${local.partition}:logs:${local.region}:${local.account_id}:log-group:${aws_cloudwatch_log_group.cloudwatch_log_group.name}:log-stream:*",
    ]
  }
}

# Create the CloudWatch log group and log stream
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = var.cloudwatch_log_group_name
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "cloudwatch_stream" {
  name           = local.account_id
  log_group_name = aws_cloudwatch_log_group.cloudwatch_log_group.name
}
