include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//iam-user-policy"
}
inputs = {
  name   = "Ren"
}
