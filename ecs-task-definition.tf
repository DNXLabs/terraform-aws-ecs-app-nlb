locals {
  port_mappings = [
    for port in var.ports : {
      hostPort      = port.port
      protocol      = port.protocol
      containerPort = port.port
    }
  ]
}

resource "aws_ecs_task_definition" "default" {

  family = "${var.cluster_name}-${var.name}"

  execution_role_arn = var.task_role_arn
  task_role_arn      = var.task_role_arn

  requires_compatibilities = [var.launch_type]

  network_mode = var.launch_type == "FARGATE" ? "awsvpc" : var.network_mode
  cpu          = var.launch_type == "FARGATE" ? var.cpu : null
  memory       = var.launch_type == "FARGATE" ? var.memory : null

  container_definitions = jsonencode([
    {
      name      = var.name
      image     = var.image
      cpu       = var.cpu
      memory    = var.memory
      essential = true
      portMappings = local.port_mappings
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.default.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "app"
        }
      }
      mountPoints = length(var.efs_mapping) == 0 ? null : [{
        sourceVolume  = "efs-${keys(var.efs_mapping)[0]}"
        containerPath = values(var.efs_mapping)[0]
      }]
      ulimits     = var.ulimits
    }
  ])

  dynamic "volume" {
    for_each = var.efs_mapping

    content {
      name = "efs-${volume.key}"

      efs_volume_configuration {
        file_system_id     = volume.key
        transit_encryption = "ENABLED"
        authorization_config {
          access_point_id = aws_efs_access_point.default[volume.key].id
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [container_definitions]
  }
}
