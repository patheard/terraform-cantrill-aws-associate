resource "aws_iam_role" "ec2_assume_role" {
  name = "ec2_assume_role"

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

# Managed read-only s3 policy
resource "aws_iam_policy_attachment" "s3_read_only_policy_attachment" {
  name       = "s3_read_only_policy_attachment"
  roles      = [aws_iam_role.ec2_assume_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Custom full s3 access policy
# resource "aws_iam_role_policy" "ec2_assume_role_policy" {
#   name = "ec2_assume_role_policy"
#   role = aws_iam_role.ec2_assume_role.id

#   policy = jsonencode({
#     "Version" : "2012-10-17",
#     "Statement" : [
#       {
#         "Action" : [
#           "s3:*"
#         ],
#         "Effect" : "Allow",
#         "Resource" : "*"
#       }
#     ]
#   })
# }

resource "aws_iam_instance_profile" "ec2_assume_role_profile" {
  name = "ec2_assume_role_profile"
  role = aws_iam_role.ec2_assume_role.name
}

data "aws_vpc" "target_vpc" {
  filter {
    name   = "tag:Name"
    values = [var.target_vpc_name]
  }
}

data "aws_subnet" "target_subnet" {
  vpc_id = data.aws_vpc.target_vpc.id

  filter {
    name   = "tag:Name"
    values = [var.target_subnet_name]
  }
}

module "instance_profile_test" {
  source = "../ec2"

  env                  = var.env
  name                 = var.instance_name
  ingress_ip           = var.instance_ingress_ip
  instance_type        = "t2.micro"
  ssh_public_key       = var.instance_ssh_public_key
  iam_instance_profile = aws_iam_instance_profile.ec2_assume_role_profile.name

  vpc_id    = data.aws_vpc.target_vpc.id
  subnet_id = data.aws_subnet.target_subnet.id
}
