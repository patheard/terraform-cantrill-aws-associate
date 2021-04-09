include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//static-site"
}
inputs = {
  website_domain = "pheard-static-demo-site"
}
