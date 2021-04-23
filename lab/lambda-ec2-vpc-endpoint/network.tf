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
    aws_security_group.privatelink.id,
  ]

  subnet_ids = [aws_subnet.subnet_test.id]
}

resource "aws_vpc_endpoint" "cloudwatch_endpoint" {
  vpc_id            = aws_vpc.vpc_test.id
  service_name      = "com.amazonaws.${local.region}.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.privatelink.id,
  ]

  subnet_ids = [aws_subnet.subnet_test.id]
}

resource "aws_security_group" "privatelink" {
  name        = "PrivateLink"
  description = "PrivateLink endpoints"
  vpc_id      = aws_vpc.vpc_test.id
}
