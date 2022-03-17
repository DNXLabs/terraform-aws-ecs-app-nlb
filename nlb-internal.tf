resource "aws_lb" "default" {
  count              = var.nlb_internal ? 1 : 0
  name               = var.nlb_internal ? "ecs-${var.name}-internal" : "ecs-${var.name}"
  internal           = var.nlb_internal
  load_balancer_type = "network"
  subnets            = var.subnets
}