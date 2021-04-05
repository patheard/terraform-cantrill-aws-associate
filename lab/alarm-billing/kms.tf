data "aws_caller_identity" "current" {}

resource "aws_kms_key" "alarm_encryption_key" {
  description         = "Alarm ${var.env} encryption key"
  enable_key_rotation = true

  # This policy allows encryption/decryption in Cloudwatch
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Id" : "key-default-1",
  "Statement" : [ 
    {
      "Sid" : "Allow IAM user to manage CMK",
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/iamadmin"
      },
      "Action" : "kms:*",
      "Resource" : "*"
    },
    {
      "Sid": "Allow CloudWatch and SES to use CMK",
      "Effect": "Allow",
      "Principal": {
          "Service": [
            "cloudwatch.amazonaws.com",
            "ses.amazonaws.com"
          ]
      },
      "Action": [
          "kms:Decrypt",
          "kms:GenerateDataKey*"
      ],
      "Resource": "*"
    }
  ]
}
EOF  
}
