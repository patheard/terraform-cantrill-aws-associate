include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//alarms"
}
inputs = {
  monthly_billing_threshold = "10"
  email                     = "pat.heard@gmail.com"
}
