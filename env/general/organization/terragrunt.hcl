include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//organization"
}
inputs = {
  account_name  = "associate-dev"
  account_email = "unique-email@some-domain.com"
}
