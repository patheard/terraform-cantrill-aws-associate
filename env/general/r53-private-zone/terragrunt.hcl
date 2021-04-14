dependencies {
  paths = ["../network"]
}

dependency "network" {
  config_path  = "../network"

  # Configure mock outputs for the `validate` command when there are no outputs available
  # This can happen if the dependency hasn't been applied yet
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    vpc_id = ""
  }  
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//r53-private-zone"
}
inputs = {
  domain_name   = "foobar.com"
  vpc_id        = dependency.network.outputs.vpc_id
}