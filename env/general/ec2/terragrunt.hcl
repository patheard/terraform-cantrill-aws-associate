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
  source = "../../../lab//ec2"
}
inputs = {
  name           = "Rick"
  instance_type  = "t2.micro"
  ingress_ip     = "0.0.0.0/0"              # Change to your IP to lock down to only you
  ssh_public_key = "ssh-rsa <your pub key>" # cat ~/.ssh/id_rsa.pub
}
