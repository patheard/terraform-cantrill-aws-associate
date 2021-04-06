resource "aws_iam_user" "this" {
  name          = var.name
  force_destroy = true
}

module "catpics" {
  source      = "../s3"
  env         = var.env
  bucket_name = "catpics"
}

module "animalpics" {
  source      = "../s3"
  env         = var.env
  bucket_name = "animalpics"
}

resource "aws_iam_user_policy" "this" {
  name   = "AllS3ExceptCats"
  user   = aws_iam_user.this.name
  policy = <<-EOF
  {
    "Version":"2012-10-17",
    "Statement":[
        {
          "Sid":"AllObjects",
          "Effect":"Allow",
          "Action":"s3:*",
          "Resource":"*"
        },
        {
          "Sid":"NoCatsForYou",
          "Effect":"Deny",
          "Action":"s3:*",
          "Resource":[
            "${module.catpics.bucket_arn}",
            "${module.catpics.bucket_arn}/*"
          ]
        }
    ]
  }
  EOF
}
