dependencies {
  paths = ["../alarms"]
}

dependency "alarms" {
  config_path  = "../alarms"
  skip_outputs = true
}

include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../module//s3"
}
inputs = {
  bucket_name = "DemoBucket"
}
