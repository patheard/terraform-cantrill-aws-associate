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
  source = "../../../module//ec2"
}
inputs = {
  instance_type = "t2.micro"
}
