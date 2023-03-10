resource "aws_security_group" "ecs_service" {
  name_prefix = "${var.name}"

  description = "SG for ECS app ${var.name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.security_group_inbound_cidrs
    content {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}