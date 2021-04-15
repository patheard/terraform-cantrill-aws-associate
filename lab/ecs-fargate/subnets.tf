data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = var.subnet_names_private
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = var.subnet_names_public
  }
}
