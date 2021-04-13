include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//ssm-parameter"
}
inputs = {
  dbstring      = "SomeLongConnectionStringMostLikely"
  dbpassword    = "ThisShouldMostCertainlyNotBeStoredInPlainText"
}
