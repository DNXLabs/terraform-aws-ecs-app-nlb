data "aws_security_group" "selected" {
  filter {
    name   = "tag:Name"
    values = ["ecs-${var.cluster_name}-nodes"]
  }
}


resource "aws_security_group_rule" "all_from_nlb_to_ecs_nodes" {
  description       = "for NLB"
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "TCP"
  security_group_id = data.aws_security_group.selected.id
  cidr_blocks       = ["0.0.0.0/0"]
}
