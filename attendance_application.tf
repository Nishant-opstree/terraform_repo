module "prod_attendance_security_group" {
  source              = "./modules/security_group"
  security_group_name = "prod_attendance_webapp"
  ingress_cidr_tcp    = "0.0.0.0/0"
  vpc_Id              = module.vpc.webapp_vpc_Id 
  ingress_cidr_ssh    = "0.0.0.0/0"
}


module "prod_attendance_security_group_rules_ingress" {
  source         = "./modules/security_group_rules"
  rule_type      = "ingress"
  rule_from_port = "0"
  rule_to_port   = "65535"
  rule_portocol  = "tcp"
  rule_cidr      = ["0.0.0.0/0"]
  rule_sec_grp   = module.prod_attendance_security_group.webapp_sec_grp_Id
}

module "prod_attendance_security_group_rules_egress" {
  source         = "./modules/security_group_rules"
  rule_type      = "egress"
  rule_from_port = "0"
  rule_to_port   = "65535"
  rule_portocol  = "tcp"
  rule_cidr      = ["0.0.0.0/0"]
  rule_sec_grp   = module.prod_attendance_security_group.webapp_sec_grp_Id
}

module "prod_attendance_lc" {
  source            = "./modules/launch_configuration"
  amis              = "ami-02d55cb47e83a99a0"
  key_name          = "ec2-linux-public-01"
  security_group_Id = [ module.prod_attendance_security_group.webapp_sec_grp_Id ]
  instance_Type     = "t2.micro"
  lc_name_prefix    =  "prod_attendance"
}

module "prod_attendance_as" {
  source                   = "./modules/auto_scalling"
  asg_name                 = "prod_attendance"
  asg_max_size             = 1
  asg_min_size             = 1
  asg_health_grace_period  = 300
  asg_health_check_type    = "EC2"
  asg_desired_capacity     = 1
  asg_force_delete         = true
  asg_launch_configuration = module.prod_attendance_lc.webapp_lc
  asg_vpc_zone_identifier  = [module.subnet_private_a.webapp_subnet_Id, module.subnet_private_b.webapp_subnet_Id]
  asg_tag_value            = "attendance"
  asg_propagate_at_launch  = true
}

module "prod_attendance_asp_up" {
  source                        = "./modules/auto_scalling_policy"
  asg_policy_name               = "prod_attendance_policy_up"
  asg_policy_scaling_adjustment = 1
  asg_policy_adjustment_type    = "ChangeInCapacity"
  asg_policy_cooldown           = 300
  asg_name                      = module.prod_attendance_as.asg.name
}


module "prod_attendance_asp_down" {
  source                        = "./modules/auto_scalling_policy"
  asg_policy_name               = "prod_attendance_policy_down"
  asg_policy_scaling_adjustment = -1
  asg_policy_adjustment_type    = "ChangeInCapacity"
  asg_policy_cooldown           = 300
  asg_name                      = module.prod_attendance_as.asg.name
  
}

module "prod_mysql_security_group" {
  source              = "./modules/security_group"
  security_group_name = "prod_mysql_webapp"
  ingress_cidr_tcp    = "0.0.0.0/0"
  vpc_Id              = module.vpc.webapp_vpc_Id 
  ingress_cidr_ssh    = "0.0.0.0/0"
}


module "prod_mysql_security_group_rules_ingress" {
  source         = "./modules/security_group_rules"
  rule_type      = "ingress"
  rule_from_port = "0"
  rule_to_port   = "65535"
  rule_portocol  = "tcp"
  rule_cidr      = ["0.0.0.0/0"]
  rule_sec_grp   = module.prod_mysql_security_group.webapp_sec_grp_Id
}

module "prod_mysql_security_group_rules_egress" {
  source         = "./modules/security_group_rules"
  rule_type      = "egress"
  rule_from_port = "0"
  rule_to_port   = "65535"
  rule_portocol  = "tcp"
  rule_cidr      = ["0.0.0.0/0"]
  rule_sec_grp   = module.prod_mysql_security_group.webapp_sec_grp_Id
}

module "prod_mysql_lc" {
  source            = "./modules/launch_configuration"
  amis              = "ami-02d55cb47e83a99a0"
  key_name          = "ec2-linux-public-01"
  security_group_Id = [ module.prod_mysql_security_group.webapp_sec_grp_Id] 
  instance_Type     = "t2.micro"
  lc_name_prefix    =  "prod_mysql" 
  
}

module "prod_mysql_asg" {
  source                   = "./modules/auto_scalling"
  asg_name                 = "prod_mysql"
  asg_max_size             = 1
  asg_min_size             = 1
  asg_health_grace_period  = 300
  asg_health_check_type    = "EC2"
  asg_desired_capacity     = 1
  asg_force_delete         = true
  asg_launch_configuration = module.prod_mysql_lc.webapp_lc
  asg_vpc_zone_identifier  = [module.subnet_private_a.webapp_subnet_Id, module.subnet_private_b.webapp_subnet_Id]
  asg_tag_value            = "mysql"
  asg_propagate_at_launch  = true
  
}

