dependencies {
  paths = ["../iam-user-policy"]
}

dependency "iam-user-policy" {
  config_path  = "../iam-user-policy"
  skip_outputs = true
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//iam-group-policy"
}
inputs = {
  catpics_bucket_name = "catpics-general-<SomeRandomId>"
  group_name          = "NoCatUsers"
  user_name           = "Ren"
}
