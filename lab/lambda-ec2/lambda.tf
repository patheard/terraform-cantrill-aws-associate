locals {
  # Flatten a full map down to a list of subnet IDs, based on the existence of the
  # map's subnet name key being in a list
  subnet_ids = flatten([
    for subnet_key, subnet in var.subnets : [
      subnet.id
    ]
    if contains(var.subnets_app, subnet_key)
  ])
}

resource "aws_lambda_function" "functions" {
  for_each = {
    for function_name in var.lambda_functions : function_name => {
      filename = "functions/${function_name}.zip"
    }
  }

  function_name = "${each.key}-${var.env}"
  role          = aws_iam_role.lambda_role.arn

  filename         = each.value.filename
  source_code_hash = filebase64sha256(each.value.filename)
  handler          = "${each.key}.lambda_handler"
  runtime          = "python3.8"

  timeout = 10

  environment {
    variables = {
      EC2_INSTANCES = ""
    }
  }

  vpc_config {
    security_group_ids = [aws_security_group.allow_lambda_on_vpc.id]
    subnet_ids         = local.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attachment,
    aws_cloudwatch_log_group.lambda_log_group,
  ]
}

resource "aws_security_group" "allow_lambda_on_vpc" {
  name        = "allow_lambda_on_vpc"
  description = "Allow Lambda function to communicate with the VPC resources"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr_block]
  }

  tags = {
    Name = "allow_lambda_on_vpc"
  }
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda"
  retention_in_days = 14
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_ec2_logging"
  path        = "/"
  description = "IAM policy for interacting with EC2 and CloudWatch"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:Start*",
          "ec2:Stop*",
          "ec2:DescribeNetworkInterfaces",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:AttachNetworkInterface"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}


# Example of using a null_resource debug variables
# resource "null_resource" "debug_subnet_ids" {
#   provisioner "local-exec" {
#     command = "echo ${join(",", local.subnet_ids)}"
#   }
#   triggers = {
#     always_run = "${timestamp()}"
#   }
# }
