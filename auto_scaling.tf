resource "aws_appautoscaling_target" "ecs_service" {
  count = var.enable_target_tracking_scaling ? length(aws_ecs_service.service) : 0

  max_capacity       = 20
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.service[count.index].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_scaling" {
  count = var.enable_target_tracking_scaling ? length(aws_appautoscaling_target.ecs_service) : 0

  name               = "${aws_ecs_service.service[count.index].name}-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

resource "aws_appautoscaling_policy" "memory_scaling" {
  count = var.enable_target_tracking_scaling ? length(aws_appautoscaling_target.ecs_service) : 0

  name               = "${aws_ecs_service.service[count.index].name}-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_service[count.index].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_service[count.index].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_service[count.index].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
