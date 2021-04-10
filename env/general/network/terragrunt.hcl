include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//network"
}
inputs = {
  vpc_name            = "a4l-vpc1"
  subnet_ipv4_newbits = 4
  subnet_ipv6_newbits = 8
  subnets = {
    "sn-reserved-A" = {
      availability_zone  = "us-east-1a"
      subnet_cidr_netnum = 0
    },
    "sn-db-A" = {
      availability_zone  = "us-east-1a"
      subnet_cidr_netnum = 1
    },
    "sn-app-A" = {
      availability_zone  = "us-east-1a"
      subnet_cidr_netnum = 2
    },
    "sn-web-A" = {
      availability_zone  = "us-east-1a"
      subnet_cidr_netnum = 3
    },
    "sn-reserved-B" = {
      availability_zone  = "us-east-1b"
      subnet_cidr_netnum = 4
    },
    "sn-db-B" = {
      availability_zone  = "us-east-1b"
      subnet_cidr_netnum = 5
    },
    "sn-app-B" = {
      availability_zone  = "us-east-1b"
      subnet_cidr_netnum = 6
    },
    "sn-web-B" = {
      availability_zone  = "us-east-1b"
      subnet_cidr_netnum = 7
    },
    "sn-reserved-C" = {
      availability_zone  = "us-east-1c"
      subnet_cidr_netnum = 8
    },
    "sn-db-C" = {
      availability_zone  = "us-east-1c"
      subnet_cidr_netnum = 9
    },
    "sn-app-C" = {
      availability_zone  = "us-east-1c"
      subnet_cidr_netnum = 10
    },
    "sn-web-C" = {
      availability_zone  = "us-east-1c"
      subnet_cidr_netnum = 11
    }
  }
}
