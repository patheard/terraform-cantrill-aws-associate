# Load balancer with port 80 listener
#tfsec:ignore:AWS005  we want the ALB exposed publicly for the demo
resource "aws_alb" "main" {
  name                       = "${var.cluster_name}-alb-${var.env}"
  subnets                    = data.aws_subnet_ids.public.ids
  security_groups            = [aws_security_group.alb_sg.id]
  enable_deletion_protection = false
}

resource "aws_alb_target_group" "app" {
  name        = "${var.cluster_name}-alb-tg-${var.env}"
  port        = 80
  protocol    = "HTTP" #tfsec:ignore:AWS004 only using HTTP for the demo
  vpc_id      = var.vpc_id
  target_type = "ip"
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = "80"
  protocol          = "HTTP" #tfsec:ignore:AWS004 only using HTTP for the demo

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
}
