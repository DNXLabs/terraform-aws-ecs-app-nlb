data "aws_route53_zone" "selected" {
  count = "${var.hostname_create ? 1 : 0}"
  name  = var.hosted_zone
}
data "aws_lb" "nlb_selected" {
  arn = "${var.nlb_arn}"
}

resource "aws_route53_record" "hostname" {
  count = "${var.hostname_create ? 1 : 0}"

  zone_id = data.aws_route53_zone.selected.*.zone_id[0]
  name    = var.hostname
  type    = "CNAME"
  ttl     = "300"
  records = list(data.aws_lb.nlb_selected.dns_name)

}
