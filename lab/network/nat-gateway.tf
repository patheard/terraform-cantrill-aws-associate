# Create an EIP and NAT gateway for each public web subnet
resource "aws_eip" "nat_gateway_eip" {
  for_each = var.subnets_public
  vpc      = true
}

resource "aws_nat_gateway" "nat_gateway" {
  for_each = var.subnets_public

  allocation_id = aws_eip.nat_gateway_eip[each.value].id
  subnet_id     = aws_subnet.subnet[each.value].id

  tags = {
    Name = "${var.vpc_name}-natgw-${each.value}"
  }

  depends_on = [
    aws_internet_gateway.a4l_igw
  ]
}

# Route table with one default route to the NAT gateway.  This causes all non-VPC destined
# traffic in the private subnets to be routed to the NAT gateway.
resource "aws_route_table" "a4l_vpc1_rt_nat_gateway" {
  for_each = var.subnets_public

  vpc_id = aws_vpc.a4l_vpc1.id

  # Only an IPv4 route is required since IPv6 have no concept of private addresses
  # (all IPv6 addrresses are publicly routable)
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway[each.value].id
  }

  tags = {
    Name = "${var.vpc_name}-rt-private-${each.value}"
  }
}

# Associate the route table with all private subnets
resource "aws_route_table_association" "route_table_private_subnet" {
  for_each = {
    for key, value in var.subnets : key => {
      subnet_name        = key
      nat_gateway_subnet = "${var.subnets_public_prefix}-${substr(key, -1, 1)}"
    }
    if !value.public_internet
  }

  subnet_id      = aws_subnet.subnet[each.value.subnet_name].id
  route_table_id = aws_route_table.a4l_vpc1_rt_nat_gateway[each.value.nat_gateway_subnet].id
}
