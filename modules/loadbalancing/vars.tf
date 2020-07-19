variable "elb_name" {
 default = "webapp-elb"
}
variable "elb_security_groups" {
 default = []
}
variable "elb_subnets" {
 default = []
}
variable "elb_cross_zone_load_balancing" {
 default = true
}


variable "elb_lb_port" {
 default = 8080
}
variable "elb_lb_protocol" {
 default = "TCP"
}
variable "elb_instance_port" {
 default = 8080
}
variable "elb_instance_protocol" {
 default = "TCP"
}

