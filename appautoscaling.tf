resource "aws_appautoscaling_target" "ecs" {
  count              = var.autoscaling_cpu ? 1 : 0
  max_capacity       = var.autoscaling_max
  min_capacity       = var.autoscaling_min
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.default.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale_cpu" {
  count              = var.autoscaling_cpu ? 1 : 0
  name               = "scale-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = var.autoscaling_target_cpu
    disable_scale_in   = false
    scale_in_cooldown  = var.autoscaling_scale_in_cooldown
    scale_out_cooldown = var.autoscaling_scale_out_cooldown

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

resource "aws_appautoscaling_scheduled_action" "scale_service_out" {
  count              = var.enable_schedule ? 1 : 0
  name               = "${var.name}-scale-out"
  service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace
  resource_id        = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
  schedule           = var.schedule_cron_stop
  timezone           = "UTC"

  scalable_target_action {
    min_capacity = 0
    max_capacity = 0
  }
}

resource "aws_appautoscaling_scheduled_action" "scale_service_in" {
  count              = var.enable_schedule ? 1 : 0
  name               = "${var.name}-scale-in"
  service_namespace  = aws_appautoscaling_target.ecs[0].service_namespace
  resource_id        = aws_appautoscaling_target.ecs[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs[0].scalable_dimension
  schedule           = var.schedule_cron_start
  timezone           = "UTC"

  scalable_target_action {
    min_capacity = var.autoscaling_min
    max_capacity = var.autoscaling_max
  }
}
