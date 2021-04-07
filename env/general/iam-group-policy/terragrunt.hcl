dependencies {
  paths = ["../iam-user-policy"]
}

dependency "iam-user-policy" {
  config_path  = "../iam-user-policy"

  # Configure mock outputs for the `validate` command when there are no outputs available
  # This can happen if the dependency hasn't been applied yet
  mock_outputs_allowed_terraform_commands = ["validate"]
  mock_outputs = {
    catpics_bucket_name = ""
    user_name           = ""
  }
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//iam-group-policy"
}
inputs = {
  catpics_bucket_name = dependency.iam-user-policy.outputs.catpics_bucket_name
  user_name           = dependency.iam-user-policy.outputs.user_name
  group_name          = "NoCatUsers"
}
