resource "aws_vpc" "a4l_vpc1" {
  cidr_block                       = "10.16.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = true

  tags = {
    Name = var.vpc_name
  }
}

# Generate the subnets based on the list given
resource "aws_subnet" "subnet" {
  for_each = var.subnets

  vpc_id            = aws_vpc.a4l_vpc1.id
  availability_zone = each.value.availability_zone

  # Generates the IPv4 and IPv6 CIDR blocks using Terraform's cidrsubnet function:
  # https://www.terraform.io/docs/language/functions/cidrsubnet.html
  # `newbits`: number of bits to extend the VPC cidr block network prefix
  # `netnum` : binary integer which must be < newbits, which is used to populate new bits added to the CIDR prefix

  # Example:
  # cidrsubnet(10.16.0.0/16, 4, 1) = 10.16.16.0/20

  # Calculations:
  # Prefix = 16 + newbits = 16 + 4 = 20
  # Host = 10.16.0.0/16 = 00001010.00010000 | 00000000.00000000
  # Host = 10.16.0.0/20 = 00001010.00010000.0000 | 0000.00000000 = 10.16.0.0/20
  # Host + 1 bit        = 00001010.00010000.0001 | 0000.00000000 = 10.16.16.0/20
  # Host + 2 bits       = 00001010.00010000.0010 | 0000.00000000 = 10.16.32.0/20
  # Host + 3 bits       = 00001010.00010000.0011 | 0000.00000000 = 10.16.48.0/20

  # Tip:
  # Use `ipcalc 10.16.0.0/16` util to help visulize
  cidr_block      = cidrsubnet(aws_vpc.a4l_vpc1.cidr_block, var.subnet_ipv4_newbits, each.value.subnet_cidr_netnum)
  ipv6_cidr_block = cidrsubnet(aws_vpc.a4l_vpc1.ipv6_cidr_block, var.subnet_ipv6_newbits, each.value.subnet_cidr_netnum)

  map_public_ip_on_launch         = each.value.public_internet
  assign_ipv6_address_on_creation = true

  tags = {
    Name = each.key
    Tier = each.value.public_internet ? "Public" : "Private"
  }
}
