include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//organization"
}
inputs = {
  dev_account_name    = "associate-dev"
  dev_account_email   = "dev@example.com"
  prod_account_name   = "associate-prod"
  prod_account_email  = "prod@example.com"  
}
