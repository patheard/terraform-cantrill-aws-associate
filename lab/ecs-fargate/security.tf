resource "aws_security_group" "alb_sg" {
  name        = "${var.cluster_name}-sg-lb-${var.env}"
  description = "Allow ingress to the load balancer on port 80"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:AWS008
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ecs_task_sg" {
  name        = "${var.cluster_name}-sg-ecs-${var.env}"
  description = "Allow ingress to ECS task on its app port"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = ["10.16.0.0/16"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["10.16.0.0/16"]
  }

  lifecycle {
    create_before_destroy = true
  }
}
