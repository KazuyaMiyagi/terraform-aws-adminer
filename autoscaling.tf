resource "aws_appautoscaling_target" "main" {
  max_capacity       = 0
  min_capacity       = 0
  resource_id        = "service/${aws_ecs_cluster.adminer.name}/${aws_ecs_service.adminer.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  lifecycle {
    ignore_changes = [
      max_capacity,
      min_capacity,
    ]
  }
}

resource "aws_appautoscaling_scheduled_action" "scale_in" {
  name               = "${aws_ecs_cluster.adminer.name}-${aws_ecs_service.adminer.name}-scale-in"
  service_namespace  = aws_appautoscaling_target.main.service_namespace
  resource_id        = aws_appautoscaling_target.main.resource_id
  scalable_dimension = aws_appautoscaling_target.main.scalable_dimension
  schedule           = var.scale_in_schedule
  scalable_target_action {
    max_capacity = 0
    min_capacity = 0
  }
}

resource "aws_appautoscaling_scheduled_action" "scale_out" {
  name               = "${aws_ecs_cluster.adminer.name}-${aws_ecs_service.adminer.name}-scale-out"
  service_namespace  = aws_appautoscaling_target.main.service_namespace
  resource_id        = aws_appautoscaling_target.main.resource_id
  scalable_dimension = aws_appautoscaling_target.main.scalable_dimension
  schedule           = var.scale_out_schedule
  scalable_target_action {
    max_capacity = 2
    min_capacity = 1
  }
}
