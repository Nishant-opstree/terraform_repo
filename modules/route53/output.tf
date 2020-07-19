output "webapp_rt53" {
  value = aws_route53_zone.webapp_rt53
}

output "webapp_rt53_record" {
  value = aws_route53_record.webapp_rt53_record
}