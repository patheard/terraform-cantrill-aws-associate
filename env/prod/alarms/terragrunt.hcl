include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../module//alarms"
}
inputs = {
  monthly_billing_threshold = "10"
  email                     = "pat.heard@gmail.com"
}