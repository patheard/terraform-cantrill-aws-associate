resource "aws_db_instance" "mysql" {
  allocated_storage                   = 10
  apply_immediately                   = true
  engine                              = "mysql"
  engine_version                      = "5.7.31"
  instance_class                      = "db.t3.micro"
  parameter_group_name                = "default.mysql5.7"
  iam_database_authentication_enabled = true
  db_subnet_group_name                = aws_db_subnet_group.mysql_subnet_group.name
  vpc_security_group_ids              = [aws_security_group.rds_sg.id]

  name     = var.db_name
  username = var.db_username
  password = var.db_password
  port     = var.db_port

  storage_encrypted   = true
  skip_final_snapshot = true
}

data "aws_subnet_ids" "database" {
  vpc_id = var.vpc_id

  filter {
    name   = "tag:Name"
    values = var.subnet_names_db
  }
}

resource "aws_db_subnet_group" "mysql_subnet_group" {
  name        = "mysql_subnet_group"
  description = "Database subnets to attach the RDS instance to"
  subnet_ids  = data.aws_subnet_ids.database.ids
}
