include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//s3-lifecycle"
}
inputs = {
  bucket_name = "lifecycle"
}
