data "aws_region" "current" {}

locals {
  region = data.aws_region.current.name
}

resource "aws_vpc" "vpc_test" {
  cidr_block           = "10.16.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "subnet_test" {
  vpc_id            = aws_vpc.vpc_test.id
  cidr_block        = "10.16.0.0/20"
  availability_zone = "${local.region}a"
}

resource "aws_vpc_endpoint" "ec2_endpoint" {
  vpc_id            = aws_vpc.vpc_test.id
  service_name      = "com.amazonaws.${local.region}.ec2"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpc_endpoint.id,
  ]

  subnet_ids          = [aws_subnet.subnet_test.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "cloudwatch_endpoint" {
  vpc_id            = aws_vpc.vpc_test.id
  service_name      = "com.amazonaws.${local.region}.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.vpc_endpoint.id,
  ]

  subnet_ids          = [aws_subnet.subnet_test.id]
  private_dns_enabled = true
}

resource "aws_security_group" "vpc_endpoint" {
  name        = "vpc_endpoint"
  description = "Allow TCP 443 over PrivateLink for AWS service endpoints"
  vpc_id      = aws_vpc.vpc_test.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "TCP"
    security_groups = [aws_security_group.allow_lambda_egress.id]
  }
}
