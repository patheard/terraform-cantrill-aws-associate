dependencies {
  paths = ["../organization"]
}

dependency "organization" {
  config_path  = "../organization"

  # Configure mock outputs for the `validate` command when there are no outputs available
  # This can happen if the dependency hasn't been applied yet
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    prod_organizational_unit_id  = ""
  }
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//organization-scp"
}
inputs = {
  organizational_unit_id = dependency.organization.outputs.prod_organizational_unit_id
}
