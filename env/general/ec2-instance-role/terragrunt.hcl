dependencies {
  paths = ["../network"]
}

dependency "network" {
  config_path  = "../network"
  skip_outputs = true
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//ec2-instance-role"
  extra_arguments "secrets" {
    commands = ["plan", "apply", "destroy"]
    arguments = [
      "-var-file=secrets.tfvars"
    ]
  }  
}
inputs = {
  instance_name         = "instance-role-test"
  target_vpc_name       = "a4l-vpc1"
  target_subnet_name    = "sn-web-A"
}