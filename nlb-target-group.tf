resource "aws_lb_listener" "ecs_tcp" {
  load_balancer_arn = var.nlb ? aws_lb.default[0].arn : var.nlb_arn
  port              = var.port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_default_tcp.arn
  }
}

resource "aws_lb_target_group" "ecs_default_tcp" {
  name        = "ecs-${var.cluster_name}-${var.name}-tcp"
  port        = var.port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = var.launch_type == "FARGATE" ? "ip" : "instance"
}