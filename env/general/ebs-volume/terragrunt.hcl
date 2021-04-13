dependencies {
  paths = ["../network"]
}

dependency "network" {
  config_path  = "../network"

  # Configure mock outputs for the `validate` command when there are no outputs available
  # This can happen if the dependency hasn't been applied yet
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    bastion_id = ""
  }
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//ebs-volume"
}
inputs = {
    volume_name     = "test-volume"
    volume_az       = "us-east-1a"
    volume_size     = 10
    aws_instance_id = dependency.network.outputs.bastion_id
}