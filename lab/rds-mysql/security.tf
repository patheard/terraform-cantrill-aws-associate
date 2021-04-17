resource "aws_security_group" "rds_sg" {
  name        = "${var.db_name}-sg"
  description = "Allow ingress to the RDS MySQL database"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.db_port
    to_port     = var.db_port
    cidr_blocks = ["10.16.0.0/16"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
