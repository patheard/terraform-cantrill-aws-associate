output "vpc_arn" {
  value = aws_vpc.a4l_vpc1.arn
}

output "vpc_id" {
  value = aws_vpc.a4l_vpc1.id
}

output "subnets" {
  value = {
    for subnet, details in aws_subnet.subnet :
    subnet => ({
      "id"                = details.id
      "arn"               = details.arn
      "availability_zone" = details.availability_zone
      "cidr_block"        = details.cidr_block,
      "ipv6_cidr_block"   = details.ipv6_cidr_block
    })
  }
}

output "igw_id" {
  value = aws_internet_gateway.a4l_igw.id
}
