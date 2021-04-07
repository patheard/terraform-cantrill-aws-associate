resource "aws_organizations_policy" "deny_s3" {
  name = "Deny S3"
  content = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      },
      {
        "Effect" : "Deny",
        "Action" : "s3:*",
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_organizations_policy_attachment" "deny_s3" {
  policy_id = aws_organizations_policy.deny_s3.id
  target_id = var.organizational_unit_id
}
