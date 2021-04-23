data "archive_file" "lambda_functions" {
  for_each = var.lambda_functions

  type        = "zip"
  source_file = "functions/${each.key}.py"
  output_path = "functions/${each.key}.zip"
}

resource "aws_lambda_function" "functions" {
  for_each = var.lambda_functions

  function_name = "${each.key}-${var.env}"
  role          = aws_iam_role.lambda_role.arn

  filename         = "functions/${each.key}.zip"
  source_code_hash = data.archive_file.lambda_functions[each.key].output_base64sha256
  handler          = "${each.key}.lambda_handler"
  runtime          = "python3.8"

  timeout = 5

  vpc_config {
    security_group_ids = [aws_security_group.allow_lambda_egress.id]
    subnet_ids         = [aws_subnet.subnet_test.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_policy_attachment,
    aws_cloudwatch_log_group.lambda_log_group,
  ]
}

resource "aws_security_group" "allow_lambda_egress" {
  name        = "allow_lambda_egress"
  description = "Allow Lambda function to communicate with AWS services"
  vpc_id      = aws_vpc.vpc_test.id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # egress {
  #   from_port       = 443
  #   to_port         = 443
  #   protocol        = "TCP"
  #   prefix_list_ids = aws_vpc_endpoint.cloudwatch_endpoint.network_interface_ids
  # }
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
