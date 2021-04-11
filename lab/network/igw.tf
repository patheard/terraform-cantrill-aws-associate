# Create the internet gateway which will be used to make the 3 
# web subnets public.
resource "aws_internet_gateway" "a4l_igw" {
  vpc_id = aws_vpc.a4l_vpc1.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Route table with one default route to the IGW.  This causes all non-VPC destined
# traffic to be routed to the IGW.
resource "aws_route_table" "a4l-vpc1-rt-web" {
  vpc_id = aws_vpc.a4l_vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.a4l_igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.a4l_igw.id
  }

  tags = {
    Name = "${var.vpc_name}-rt-web"
  }
}

# Associate the route table with the public web subnets
resource "aws_route_table_association" "route_table_web_subnet" {
  for_each = var.subnets_public

  subnet_id      = aws_subnet.subnet[each.value].id
  route_table_id = aws_route_table.a4l-vpc1-rt-web.id
}
