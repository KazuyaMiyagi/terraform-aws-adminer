resource "aws_ecs_cluster" "adminer" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "adminer" {
  family             = var.task_family_name
  network_mode       = "awsvpc"
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = templatefile("${path.module}/templates/adminer.json.tmpl", {
    image          = var.image
    awslogs_group  = var.adminer_log_group_name
    awslogs_region = var.aws_region
  })
  requires_compatibilities = [
    "FARGATE",
  ]
}

resource "aws_ecs_service" "adminer" {
  name                               = var.service_name
  platform_version                   = var.platform_version
  cluster                            = aws_ecs_cluster.adminer.arn
  task_definition                    = aws_ecs_task_definition.adminer.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100

  network_configuration {
    subnets          = var.adminer_subnets
    security_groups  = var.adminer_security_groups
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.adminer_target_group_arn
    container_name   = "adminer"
    container_port   = 8080
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]
  }
}
