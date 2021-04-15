# Fargate cluster, task and service definition
resource "aws_ecs_cluster" "fargate" {
  name = "${var.cluster_name}-${var.env}"
}

resource "aws_ecs_task_definition" "app" {
  family                   = "app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory

  container_definitions = jsonencode([
    {
      "cpu" : var.fargate_cpu,
      "image" : var.app_image,
      "memory" : var.fargate_memory,
      "name" : "app-container-${var.env}",
      "networkMode" : "awsvpc",
      "portMappings" : [
        {
          "containerPort" : var.app_port,
          "hostPort" : var.app_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "main" {
  name            = "${var.cluster_name}-service-${var.env}"
  cluster         = aws_ecs_cluster.fargate.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = var.app_count

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_task_sg.id]
    subnets          = data.aws_subnet_ids.private.ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "app-container-${var.env}"
    container_port   = var.app_port
  }

  depends_on = [
    aws_alb_listener.front_end
  ]
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.cluster_name}-ecsTaskExecutionRole-${var.env}"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
