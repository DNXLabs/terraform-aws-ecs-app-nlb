resource "aws_lb_listener" "ecs_tcp" {
  load_balancer_arn = var.nlb_internal ? try(aws_lb.default[0].arn, "") : var.nlb_arn
  port              = var.port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_default_tcp.arn
  }
}

resource "random_string" "tg_nlb_prefix" {
  length  = 4
  upper   = false
  special = false
}

resource "aws_lb_target_group" "ecs_default_tcp" {
  name        = format("%s-%s-tcp", substr("${var.cluster_name}-${var.name}", 0, 23), random_string.tg_nlb_prefix.result)
  port        = var.port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = var.launch_type == "FARGATE" ? "ip" : "instance"
}