locals {
  full_group_name = "${var.group_name}-${var.env}"
}

data "aws_iam_user" "ren" {
  user_name = var.user_name
}

data "aws_s3_bucket" "catpics" {
  bucket = var.catpics_bucket_name
}

resource "aws_iam_group" "this" {
  name = local.full_group_name
}

resource "aws_iam_group_membership" "this" {
  name = "${local.full_group_name}-group-membership"

  users = [
    data.aws_iam_user.ren.user_name
  ]

  group = aws_iam_group.this.name
}

resource "aws_iam_group_policy" "this" {
  name  = "AllS3ExceptCats"
  group = aws_iam_group.this.name

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllObjects",
        "Effect" : "Allow",
        "Action" : "s3:*",
        "Resource" : "*"
      },
      {
        "Sid" : "NoCatsForYou",
        "Effect" : "Deny",
        "Action" : "s3:*",
        "Resource" : [
          data.aws_s3_bucket.catpics.arn,
          "${data.aws_s3_bucket.catpics.arn}/*"
        ]
      }
    ]
  })
}
