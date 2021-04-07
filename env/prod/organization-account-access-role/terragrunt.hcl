include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//organization-account-access-role"
}
inputs = {
  account_id = "1234567890" # Set to your `general` account ID
}
