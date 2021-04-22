dependencies {
  paths = ["../network"]
}

dependency "network" {
  config_path = "../network"

  # Configure mock outputs for the `validate` command when there are no outputs available
  # This can happen if the dependency hasn't been applied yet
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    subnets = {
      "sn-app-A" = {
        "id" = ""
      }
      "sn-app-B" = {
        "id" = ""
      }
      "sn-app-C" = {
        "id" = ""
      }
    }
    vpc_id = ""
  }
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//lambda-ec2"
}
inputs = {
  lambda_functions = ["start", "stop"]
  subnets_lambda   = ["sn-web-A", "sn-web-B", "sn-web-C"]
  subnets          = dependency.network.outputs.subnets
  vpc_id           = dependency.network.outputs.vpc_id
  vpc_cidr_block   = "10.16.0.0/16"
}