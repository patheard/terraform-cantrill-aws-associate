include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//organization"
  extra_arguments "secrets" {
    commands = ["plan", "apply"]
    arguments = [
      "-var-file=secrets.tfvars"
    ]
  }
}
inputs = {
  dev_account_name    = "associate-dev"
  prod_account_name   = "associate-prod"
  # Set these in a secrets.tfvars that could be encrypted or passed via pipeline args
  # dev_account_email   = "dev@example.com"
  # prod_account_email  = "prod@example.com"   
}
