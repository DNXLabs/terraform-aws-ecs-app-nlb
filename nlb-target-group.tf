resource "aws_lb_listener" "ecs_tcp" {
  for_each = {for port in var.ports : port.port => port}
  load_balancer_arn = var.nlb ? try(aws_lb.default[0].arn, "") : var.nlb_arn
  port              = each.value.port
  protocol          = each.value.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_default_tcp[each.value.port].arn
  }
}

resource "random_string" "tg_nlb_prefix" {
  length  = 4
  upper   = false
  special = false
}

resource "aws_lb_target_group" "ecs_default_tcp" {
  for_each = {for port in var.ports : port.port => port}
  name        = format("%s-%s-tcp", substr("${var.cluster_name}-${var.name}-${each.value.port}", 0, 23), random_string.tg_nlb_prefix.result)
  port        = each.value.port
  protocol    = each.value.protocol
  vpc_id      = var.vpc_id
  target_type = var.launch_type == "FARGATE" ? "ip" : "instance"
}