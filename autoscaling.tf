resource "aws_appautoscaling_target" "main" {
  max_capacity       = var.desired_count
  min_capacity       = var.desired_count
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

resource "aws_appautoscaling_scheduled_action" "main" {
  for_each = var.autoscaling_settings

  name               = each.value.name
  service_namespace  = aws_appautoscaling_target.main.service_namespace
  resource_id        = aws_appautoscaling_target.main.resource_id
  scalable_dimension = aws_appautoscaling_target.main.scalable_dimension
  schedule           = each.value.schedule
  scalable_target_action {
    max_capacity = each.value.max_capacity
    min_capacity = each.value.min_capacity
  }
}
