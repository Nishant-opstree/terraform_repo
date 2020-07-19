variable "route53_name" {
 default = "webapp-rt53"
}
variable "route53_vpc_id" {
 default = "vpc-0ba1b063"
}
variable "route53_record_name" {
 default = "example.com"
}
variable "route53_record_type" {
 default = "A"
}
variable "route53_elb_dns" {
 default = ""
}
variable "route53_elb_zone_id" {
 default = ""
}
variable "route53_evaluate_target_health" {
 default = true
}