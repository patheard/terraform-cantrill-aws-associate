
locals {
  vars = read_terragrunt_config("../env_vars.hcl")
}

inputs = {
  env = "${local.vars.inputs.env}"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    region         = "us-east-1"
    bucket         = "pheard-associate-${local.vars.inputs.env}-tfstate"
    key            = "${path_relative_to_include()}/state.tfstate"
    dynamodb_table = "pheard-associate-statelock"
    encrypt        = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
EOF
}
