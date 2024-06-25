resource "aws_ecs_service" "default" {
  name                              = var.name
  cluster                           = var.cluster_name
  task_definition                   = aws_ecs_task_definition.default.arn
  desired_count                     = var.autoscaling_min
  iam_role                          = var.launch_type == "FARGATE" ? null : var.service_role_arn
  health_check_grace_period_seconds = var.service_health_check_grace_period_seconds
  enable_execute_command            = true

  dynamic "load_balancer" {
    for_each = { for port in var.ports : port.port => port }
    content {
      target_group_arn = aws_lb_target_group.ecs_default_tcp[load_balancer.value.port].arn
      container_name   = var.name
      container_port   = load_balancer.value.port
    }
  }

  dynamic "placement_constraints" {
    for_each = var.launch_type == "FARGATE" ? [] : var.placement_constraints
    content {
      expression = lookup(placement_constraints.value, "expression", null)
      type       = placement_constraints.value.type
    }
  }

  dynamic "network_configuration" {
    for_each = var.launch_type == "FARGATE" ? [var.subnets] : []
    content {
      subnets          = var.subnets
      security_groups  = toset(concat([aws_security_group.ecs_service.id], var.security_groups))
      assign_public_ip = var.assign_public_ip
    }
  }

  dynamic "ordered_placement_strategy" {
    for_each = var.launch_type == "FARGATE" ? [] : var.ordered_placement_strategy
    content {
      field = lookup(ordered_placement_strategy.value, "field", null)
      type  = ordered_placement_strategy.value.type
    }
  }

  capacity_provider_strategy {
    capacity_provider = var.launch_type == "FARGATE" ? (var.fargate_spot ? "FARGATE_SPOT" : "FARGATE") : "${var.cluster_name}-capacity-provider"
    weight            = 1
    base              = 0
  }

  lifecycle {
    ignore_changes = [load_balancer, task_definition, desired_count]
  }
}

resource "aws_security_group" "ecs_service" {
  name_prefix = var.name

  description = "SG for ecs service app ${var.name}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group_rule" "ecs_service_from_nlb" {
  # for_each                 = var.nlb == true ? { for port in var.ports : port.port => port } : []
  for_each                 = { for port in(var.nlb == true ? var.ports : []) : port.port => port }
  type                     = "ingress"
  from_port                = each.value.port
  to_port                  = each.value.port
  protocol                 = each.value.protocol
  security_group_id        = aws_security_group.ecs_service.id
  source_security_group_id = aws_security_group.nlb[0].id
}
