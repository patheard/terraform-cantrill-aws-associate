data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_kms_key" "root" {
  description         = "Root CMK for ${var.env}"
  enable_key_rotation = true

  # Create key administrators
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "key-default-1",
    "Statement" : [
      {
        "Sid" : "Allow IAM root user to manage CMK",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${local.account_id}:root"
        },
        "Action" : "kms:*",
        "Resource" : "*"
      },
      {
        "Sid" : "Allow access for key admin",
        "Effect" : "Allow",
        "Principal" : { "AWS" : [
          "arn:aws:iam::${local.account_id}:user/iamadmin"
        ] },
        "Action" : [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_kms_alias" "root_alias" {
  name          = "alias/root-${var.env}"
  target_key_id = aws_kms_key.root.key_id
}
