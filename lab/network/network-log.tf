# Create logging for VPC network traffic
resource "aws_flow_log" "flow_log" {
  iam_role_arn    = aws_iam_role.flow_role.arn
  log_destination = aws_cloudwatch_log_group.flow_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.a4l_vpc1.id
}

resource "aws_cloudwatch_log_group" "flow_log_group" {
  name = "/aws/network"
}

resource "aws_iam_role" "flow_role" {
  name = "flow_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "vpc-flow-logs.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "flow_role_policy" {
  name = "flow_role_policy"
  role = aws_iam_role.flow_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        "Effect" : "Allow",
        "Resource" : "*"
      }
    ]
  })
}
