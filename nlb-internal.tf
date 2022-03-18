resource "random_string" "nlb_prefix" {
  length  = 4
  upper   = false
  special = false
}

resource "aws_lb" "default" {
  count              = var.nlb_internal ? 1 : 0
  name               = var.nlb_internal ? format("%s-%s-tcp", substr("${var.cluster_name}-${var.name}-internal", 0, 23), random_string.nlb_prefix.result) : format("%s-%s-tcp", substr("ecs-${var.cluster_name}-${var.name}", 0, 23), random_string.nlb_prefix.result)
  internal           = var.nlb_internal
  load_balancer_type = "network"
  subnets            = var.subnets
}