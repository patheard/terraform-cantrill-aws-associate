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
  source = "../../../lab//rds-mysql"
  extra_arguments "secrets" {
    commands = ["plan", "apply", "destroy"]
    arguments = [
      "-var-file=secrets.tfvars"
    ]
  }
}
inputs = {
  db_name              = "mysql_test"
  db_username          = "root"
  db_password          = "superSecretNestPas"
  db_port              = 3306
  instance_name        = "mysql_test_connect"
  instance_subnet_name = "sn-web-A"
  subnet_names_db      = ["sn-db-A", "sn-db-B", "sn-db-C"]
  vpc_id               = dependency.network.outputs.vpc_id
}