# This is only a partial implemention of IAM authentication roles:
# https://aws.amazon.com/premiumsupport/knowledge-center/users-connect-rds-iam/
# The remaining steps are to:
# 1. Create a user in the MySQL database using the `AWSAuthenticationPlugin` plugin to allow token based login
# 2. Add this user to the role policy.
# 3. Login to the EC2 test instance and generate an auth token.
# 4. Use this auth token with the `mysql` connection attempts.

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  region     = data.aws_region.current.name
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_iam_instance_profile" "mysql_connect_profile" {
  name = "mysql_connect_profile"
  role = aws_iam_role.mysql_connect.name
}

resource "aws_iam_role" "mysql_connect" {
  name                  = "mysql_connect"
  force_detach_policies = true

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "rds_connect_role_policy" {
  name_prefix = "rds_connect_policy"
  role        = aws_iam_role.mysql_connect.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "rds-db:connect"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:rds-db:${local.region}:${local.account_id}:dbuser:${aws_db_instance.mysql.identifier}/${var.db_username}"
      }
    ]
  })
}

data "aws_subnet" "target_subnet" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = [var.instance_subnet_name]
  }
}

module "instance_test" {
  source = "../ec2"

  env                  = var.env
  name                 = var.instance_name
  ingress_ip           = var.instance_ingress_ip
  instance_type        = "t2.micro"
  ssh_public_key       = var.instance_ssh_public_key
  iam_instance_profile = aws_iam_instance_profile.mysql_connect_profile.name

  vpc_id    = var.vpc_id
  subnet_id = data.aws_subnet.target_subnet.id
}
