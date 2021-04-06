dependencies {
  paths = ["../iam-user-policy"]
}

dependency "iam-user-policy" {
  config_path  = "../iam-user-policy"
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//iam-group-policy"
}
inputs = {
  catpics_bucket_name = dependency.iam-user-policy.outputs.catpics_bucket_name
  group_name          = "NoCatUsers"
  user_name           = "Ren"
}
