module "test_gateway_security_group" {
  source              = "./modules/security_group"
  security_group_name = "test_gateway_webapp"
  ingress_cidr_tcp    = "0.0.0.0/0"
  vpc_Id              = module.vpc.webapp_vpc_Id 
  ingress_cidr_ssh    = "0.0.0.0/0"
}


module "test_gateway_security_group_rules_ingress" {
  source         = "./modules/security_group_rules"
  rule_type      = "ingress"
  rule_from_port = "0"
  rule_to_port   = "65535"
  rule_portocol  = "tcp"
  rule_cidr      = ["0.0.0.0/0"]
  rule_sec_grp   = module.test_gateway_security_group.webapp_sec_grp_Id
}

module "test_gateway_security_group_rules_egress" {
  source         = "./modules/security_group_rules"
  rule_type      = "egress"
  rule_from_port = "0"
  rule_to_port   = "65535"
  rule_portocol  = "tcp"
  rule_cidr      = ["0.0.0.0/0"]
  rule_sec_grp   = module.test_gateway_security_group.webapp_sec_grp_Id
}

module "test_gateway_load_balancer" {
  source                        = "./modules/loadbalancing"
  elb_name                      = "testgatewaylb"
  elb_security_groups           = [ module.test_gateway_security_group.webapp_sec_grp_Id ]
  elb_subnets                   = [module.subnet_private_a.webapp_subnet_Id, module.subnet_private_b.webapp_subnet_Id]
  elb_cross_zone_load_balancing = true
  elb_internal                  = true
  elb_lb_port                   = 9200
  elb_lb_protocol               = "TCP"
  elb_instance_port             = 9200
  elb_instance_protocol         = "TCP"
}

module "test_gateway_lc" {
  source            = "./modules/launch_configuration"
  amis              = "ami-02d55cb47e83a99a0"
  key_name          = "ec2-linux-public-01"
  security_group_Id = [ module.test_gateway_security_group.webapp_sec_grp_Id] 
  instance_Type     = "t2.micro"
  lc_name_prefix    =  "test_gateway" 
  
}

module "test_gateway_asg" {
  source                   = "./modules/auto_scalling"
  asg_name                 = "test_gateway"
  asg_max_size             = 1
  asg_min_size             = 1
  asg_health_grace_period  = 300
  asg_health_check_type    = "EC2"
  asg_lb                   = [ module.test_gateway_load_balancer.webapp_elb.id ]
  asg_desired_capacity     = 1
  asg_force_delete         = true
  asg_launch_configuration = module.test_gateway_lc.webapp_lc
  asg_vpc_zone_identifier  = [module.subnet_private_a.webapp_subnet_Id, module.subnet_private_b.webapp_subnet_Id]
  asg_tag_value            = "test_gateway"
  asg_propagate_at_launch  = true
  
}


