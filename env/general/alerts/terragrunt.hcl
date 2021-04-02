include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../module//alerts"
}
inputs = {
  monthly_billing_threshold = "10"
}
