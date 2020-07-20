resource "aws_elb" "webapp_elb" {
  name                      = var.elb_name
  security_groups           = var.elb_security_groups
  subnets                   = var.elb_subnets
  cross_zone_load_balancing = var.elb_cross_zone_load_balancing
  internal                  = var.elb_internal
  
  listener {
    lb_port           = var.elb_lb_port
    lb_protocol       = var.elb_lb_protocol
    instance_port     = var.elb_instance_port
    instance_protocol = var.elb_instance_protocol
  }
}
