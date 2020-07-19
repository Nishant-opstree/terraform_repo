resource "aws_route53_zone" "webapp_rt53" {
  name = var.route53_name

  vpc {
    vpc_id = var.route53_vpc_id
  }
}

resource "aws_route53_record" "webapp_rt53_record" {
  zone_id = "${aws_route53_zone.webapp_rt53.zone_id}"
  name    = var.route53_record_name
  type    = var.route53_record_type

  alias {
    name                   = var.route53_elb_dns
    zone_id                = var.route53_elb_zone_id
    evaluate_target_health = var.route53_evaluate_target_health
  }
}