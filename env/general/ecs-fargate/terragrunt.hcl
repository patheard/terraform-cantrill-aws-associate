dependencies {
  paths = ["../network"]
}

dependency "network" {
  config_path = "../network"

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
  source = "../../../lab//ecs-fargate"
}
inputs = {
  app_image            = "acantril/containercat:latest"
  app_port             = 80
  app_count            = 2
  cluster_name         = "test-fargate"
  fargate_cpu          = 512
  fargate_memory       = 1024
  subnet_names_private = ["sn-app-A", "sn-app-B", "sn-app-C"]
  subnet_names_public  = ["sn-web-A", "sn-web-B", "sn-web-C"]
  vpc_id               = dependency.network.outputs.vpc_id
}
