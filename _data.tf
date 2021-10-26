data "aws_region" "current" {}

data "aws_iam_account_alias" "current" {
  count = var.alarm_prefix == "" ? 1 : 0
}

data "aws_lb" "nlb_selected" {
  count = var.nlb_arn != "" ? 1 : 0
  arn   = var.nlb_arn
}