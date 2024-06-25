resource "random_string" "nlb_prefix" {
  length  = 4
  upper   = false
  special = false
}

locals {
  name = var.nlb_internal ? format("%s-%s-int", substr("${var.cluster_name}-${var.name}", 0, 23), random_string.nlb_prefix.result) : format("%s-%s", substr("${var.cluster_name}-${var.name}", 0, 27), random_string.nlb_prefix.result)
}

resource "aws_lb" "default" {
  count              = var.nlb ? 1 : 0
  name               = local.name
  internal           = var.nlb_internal
  load_balancer_type = "network"
  subnets            = var.nlb_subnets_ids
  security_groups    = [aws_security_group.nlb[0].id]
}

resource "aws_security_group" "nlb" {
  count = var.nlb ? 1 : 0

  name_prefix = local.name

  description = "SG for NLB app ${local.name}"
  vpc_id      = var.vpc_id


  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.security_group_nlb_inbound_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
