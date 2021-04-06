dependencies {
  paths = ["../alarm-billing"]
}

dependency "alarm-billing" {
  config_path  = "../alarm-billing"
  skip_outputs = true
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//s3"
}
inputs = {
  bucket_name = "DemoBucket"
}
