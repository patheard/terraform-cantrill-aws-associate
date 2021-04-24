include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../lab//lambda-ec2-vpc-endpoint"
}
inputs = {
  lambda_functions = ["start", "stop"]
}