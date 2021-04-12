include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//network"
  extra_arguments "secrets" {
    commands = ["plan", "apply", "destroy"]
    arguments = [
      "-var-file=secrets.tfvars"
    ]
  }
}
inputs = {
  vpc_name              = "a4l-vpc1"
  subnet_ipv4_newbits   = 4
  subnet_ipv6_newbits   = 8
  subnets_public        = ["sn-web-A", "sn-web-B", "sn-web-C"]
  subnets_public_prefix = "sn-web"
  subnets = {
    "sn-reserved-A" = {
      availability_zone  = "us-east-1a"
      subnet_cidr_netnum = 0
      public_internet    = false
    },
    "sn-db-A" = {
      availability_zone  = "us-east-1a"
      subnet_cidr_netnum = 1
      public_internet    = false
    },
    "sn-app-A" = {
      availability_zone  = "us-east-1a"
      subnet_cidr_netnum = 2
      public_internet    = false
    },
    "sn-web-A" = {
      availability_zone  = "us-east-1a"
      subnet_cidr_netnum = 3
      public_internet    = true
    },
    "sn-reserved-B" = {
      availability_zone  = "us-east-1b"
      subnet_cidr_netnum = 4
      public_internet    = false
    },
    "sn-db-B" = {
      availability_zone  = "us-east-1b"
      subnet_cidr_netnum = 5
      public_internet    = false
    },
    "sn-app-B" = {
      availability_zone  = "us-east-1b"
      subnet_cidr_netnum = 6
      public_internet    = false
    },
    "sn-web-B" = {
      availability_zone  = "us-east-1b"
      subnet_cidr_netnum = 7
      public_internet    = true
    },
    "sn-reserved-C" = {
      availability_zone  = "us-east-1c"
      subnet_cidr_netnum = 8
      public_internet    = false
    },
    "sn-db-C" = {
      availability_zone  = "us-east-1c"
      subnet_cidr_netnum = 9
      public_internet    = false
    },
    "sn-app-C" = {
      availability_zone  = "us-east-1c"
      subnet_cidr_netnum = 10
      public_internet    = false
    },
    "sn-web-C" = {
      availability_zone  = "us-east-1c"
      subnet_cidr_netnum = 11
      public_internet    = true
    }
  }
  
  bastion_name          = "bastion-web-A"
  bastion_instance_type = "t2.micro"
  bastion_subnet_name   = "sn-web-A"
  # Set these in a secret.tfvars file in the same directory
  # bastion_ingress_ip      = "0.0.0.0/0"
  # bastion_ssh_public_key  = "cat ~/.ssh/id_rsa.pub"

  private_host_name        = "private-app-B"
  private_host_subnet_name = "sn-app-B"
}
