# LOCALS

locals {
  common_name                  = "${var.environment_identifier}-${var.app_hostnames["external"]}"
  application_endpoint         = "${var.app_hostnames["external"]}"
  short_environment_identifier = "${var.short_environment_identifier}-${var.app_name}"
  vpc_id                       = "${var.vpc_id}"
  config_bucket                = "${var.config_bucket}"
  public_subnet_ids            = ["${var.public_subnet_ids}"]
  private_subnet_ids           = ["${var.private_subnet_ids}"]
  ext_lb_security_groups       = ["${var.ext_lb_security_groups}"]
  int_lb_security_groups       = ["${var.int_lb_security_groups}"]
  certificate_arn              = ["${var.certificate_arn}"]
  access_logs_bucket           = "${var.access_logs_bucket}"
  public_zone_id               = "${var.public_zone_id}"
  external_domain              = "${var.external_domain}"
  internal_domain              = "${var.internal_domain}"
  instance_security_groups     = ["${var.instance_security_groups}"]

  s3_bucket_config = "${var.s3_bucket_config}"
  spg_build_inv_dir = "${var.spg_build_inv_dir}"

}




############################################
# CREATE INTERNAL LB FOR spg
############################################
module "create_app_alb_int" {
  source              = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//create_lb"
  lb_name             = "${local.short_environment_identifier}-int"
  subnet_ids          = ["${local.private_subnet_ids}"]
  s3_bucket_name      = "${local.access_logs_bucket}"
  security_groups     = ["${local.int_lb_security_groups}"]
  tags                = "${var.tags}"
  internal            = true
}

###############################################
# Create INTERNAL route53 entry for spg lb
###############################################

resource "aws_route53_record" "dns_int_entry" {
  zone_id = "${local.public_zone_id}"
  name    = "${local.application_endpoint}-int.${local.external_domain}"
  type    = "A"

  alias {
    name                   = "${module.create_app_alb_int.lb_dns_name}"
    zone_id                = "${module.create_app_alb_int.lb_zone_id}"
    evaluate_target_health = false
  }
}


//need a dns record for the crc server, which shouldn't have need a load balancer as it
//resource "aws_route53_record" "dns_int_direct_entry" {
//  zone_id = "${local.public_zone_id}"
//  name    = "${local.application_endpoint}-int-direct.${local.external_domain}"
//  type    = "A"
//
//  alias {
//    name                   = "${module.create_app_alb_int.lb_dns_name}"
//    zone_id                = "${module.create_app_alb_int.lb_zone_id}"
//    evaluate_target_health = false
//  }
//}



############################################
# CREATE EXTERNAL LB FOR spg
############################################
//module "create_app_alb_ext" {
//  source          = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//create_lb"
//  lb_name         = "${local.short_environment_identifier}-ext"
//  subnet_ids      = ["${local.public_subnet_ids}"]
//  s3_bucket_name  = "${local.access_logs_bucket}"
//  security_groups = ["${local.ext_lb_security_groups}"]
//  tags            = "${var.tags}"
//  internal = false
//}

###############################################
# Create EXTERNAL route53 entry for spg lb
###############################################

//resource "aws_route53_record" "dns_ext_entry" {
//  zone_id = "${local.public_zone_id}"
//  name    = "${local.application_endpoint}.${local.external_domain}"
//  type    = "A"
//
//  alias {
//    name                   = "${module.create_app_alb_ext.lb_dns_name}"
//    zone_id                = "${module.create_app_alb_ext.lb_zone_id}"
//    evaluate_target_health = false
//  }
//}







#-------------------------------------------------------------
### Create app listeners int
#-------------------------------------------------------------

#module "create_app_alb_int_listener_with_https" {
#  source           = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//create_listener_with_https"
#  lb_port          = "${var.alb_backend_port}"
#  lb_protocol      = "${var.alb_listener_protocol}"
#  lb_arn           = "${module.create_app_alb_int.lb_arn}"
#  target_group_arn = "${module.create_app_alb_int_targetgrp.target_group_arn}"
#  ssl_policy       = "${var.public_ssl_policy}"
#  certificate_arn  = ["${local.certificate_arn}"]
#}

module "create_app_alb_int_listener" {
  source           = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//create_listener"
  lb_port          = "${var.alb_http_port}"
  lb_protocol      = "HTTP"
  lb_arn           = "${module.create_app_alb_int.lb_arn}"
  target_group_arn = "${module.create_app_alb_int_targetgrp.target_group_arn}"
}



#-------------------------------------------------------------
### Create app listeners ext
#-------------------------------------------------------------

//module "create_app_alb_ext_listener_with_https" {
//  source           = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//create_listener_with_https"
//  lb_port          = "${var.alb_backend_port}"
//  lb_protocol      = "${var.alb_listener_protocol}"
//  lb_arn           = "${module.create_app_alb_ext.lb_arn}"
//  target_group_arn = "${module.create_app_alb_ext_targetgrp.target_group_arn}"
//  ssl_policy       = "${var.public_ssl_policy}"
//  certificate_arn  = ["${local.certificate_arn}"]
//}

//module "create_app_alb_ext_listener" {
//  source           = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//create_listener"
//  lb_port          = "${var.alb_http_port}"
//  lb_protocol      = "HTTP"
//  lb_arn           = "${module.create_app_alb_ext.lb_arn}"
//  target_group_arn = "${module.create_app_alb_ext_targetgrp.target_group_arn}"
//}

############################################
# CREATE INT TARGET GROUPS FOR APP PORTS
############################################

module "create_app_alb_int_targetgrp" {
  source               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//targetgroup"
  appname              = "${local.short_environment_identifier}-int"
  target_port          = "${var.backend_app_port}"
  target_protocol      = "${var.backend_app_protocol}"
  vpc_id               = "${var.vpc_id}"
  check_interval       = "${var.backend_check_interval}"
  check_path           = "${var.backend_check_app_path}"
  check_port           = "${var.backend_app_port}"
  check_protocol       = "${var.backend_app_protocol}"
  timeout              = "${var.backend_timeout}"
  healthy_threshold    = "${var.backend_healthy_threshold}"
  unhealthy_threshold  = "${var.backend_unhealthy_threshold}"
  return_code          = "${var.backend_return_code}"
  deregistration_delay = "${var.deregistration_delay}"
  target_type          = "${var.target_type}"
  tags                 = "${var.tags}"
}



############################################
# CREATE EXT TARGET GROUPS FOR APP PORTS
############################################

//module "create_app_alb_ext_targetgrp" {
//  source               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//loadbalancer//alb//targetgroup"
//  appname              = "${local.short_environment_identifier}-ext"
//  target_port          = "${var.backend_app_port}"
//  target_protocol      = "${var.backend_app_protocol}"
//  vpc_id               = "${var.vpc_id}"
//  check_interval       = "${var.backend_check_interval}"
//  check_path           = "${var.backend_check_app_path}"
//  check_port           = "${var.backend_app_port}"
//  check_protocol       = "${var.backend_app_protocol}"
//  timeout              = "${var.backend_timeout}"
//  healthy_threshold    = "${var.backend_healthy_threshold}"
//  unhealthy_threshold  = "${var.backend_unhealthy_threshold}"
//  return_code          = "${var.backend_return_code}"
//  deregistration_delay = "${var.deregistration_delay}"
//  target_type          = "${var.target_type}"
//  tags                 = "${var.tags}"
//}

############################################
# CREATE ECS CLUSTER FOR spg
############################################
# ##### ECS Cluster

module "ecs_cluster" {
  source       = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//ecs//ecs_cluster"
  cluster_name = "${local.common_name}"
}

############################################
# CREATE LOG GROUPS FOR CONTAINER LOGS
############################################

module "create_loggroup" {
  source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//cloudwatch//loggroup"
  log_group_path           = "${var.environment_identifier}"
  loggroupname             = "${var.app_name}"
  cloudwatch_log_retention = "${var.cloudwatch_log_retention}"
  tags                     = "${var.tags}"
}

############################################
# CREATE ECS TASK DEFINTIONS
############################################

data "aws_ecs_task_definition" "app_task_definition" {
  task_definition = "${module.app_task_definition.task_definition_family}"
  depends_on      = ["module.app_task_definition"]
}

data "template_file" "app_task_definition" {
  template = "${file("task_definitions/${var.backend_app_template_file}")}"

  vars {
    image_url             = "${var.image_url}"
    container_name        = "${var.app_name}"
    s3_bucket_config      = "${local.config_bucket}"
    version               = "${var.image_version}"
    log_group_name        = "${module.create_loggroup.loggroup_name}"
    log_group_region      = "${var.region}"
    memory                = "${var.backend_ecs_memory}"
    cpu_units             = "${var.backend_ecs_cpu_units}"
    data_volume_name      = "key_dir"
    data_volume_host_path = "${var.keys_dir}"
    kibana_host           = "${var.kibana_host}"
    s3_bucket_config = "${var.s3_bucket_config}"
    spg_build_inv_dir = "${var.spg_build_inv_dir}"
  }
}

module "app_task_definition" {
  source   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//ecs//ecs-taskdefinitions//appwith_single_volume"
  app_name = "${local.common_name}"

  container_name        = "${var.app_name}"
  container_definitions = "${data.template_file.app_task_definition.rendered}"

  data_volume_name      = "key_dir"
  data_volume_host_path = "${var.keys_dir}"

  data_volume_host_path = "${var.keys_dir}"
  data_volume_host_path = "${var.keys_dir}"
}

############################################
# CREATE ECS SERVICES
############################################

module "app_service" {
  source                          = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//ecs/ecs_service//withloadbalancer//alb"
  servicename                     = "${local.common_name}"
  clustername                     = "${module.ecs_cluster.ecs_cluster_id}"
  ecs_service_role                = "${var.ecs_service_role}"
  target_group_arn                = "${module.create_app_alb_int_targetgrp.target_group_arn}"
  containername                   = "${var.app_name}"
  containerport                   = "${var.backend_app_port}"
  task_definition_family          = "${module.app_task_definition.task_definition_family}"
  task_definition_revision        = "${module.app_task_definition.task_definition_revision}"
  current_task_definition_version = "${data.aws_ecs_task_definition.app_task_definition.revision}"
  service_desired_count           = "${var.service_desired_count}"
}

############################################
# CREATE USER DATA FOR EC2 RUNNING SERVICES
############################################

data "template_file" "user_data" {
  template = "${file("${var.user_data}")}"

  vars {
    keys_dir             = "${var.cache_home}"
    ebs_device           = "${var.ebs_device_name}"
    app_name             = "${var.app_name}"
    env_identifier       = "${var.environment_identifier}"
    short_env_identifier = "${var.short_environment_identifier}"
    cluster_name         = "${module.ecs_cluster.ecs_cluster_name}"
    log_group_name       = "${module.create_loggroup.loggroup_name}"
    container_name       = "${var.app_name}"
    keys_dir             = "${var.keys_dir}"
  }
}

############################################
# CREATE LAUNCH CONFIG FOR EC2 RUNNING SERVICES
############################################

module "launch_cfg" {
  source                      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//launch_configuration//blockdevice"
  launch_configuration_name   = "${local.common_name}"
  image_id                    = "${var.ami_id}"
  instance_type               = "${var.instance_type}"
  volume_size                 = "${var.volume_size}"
  instance_profile            = "${var.instance_profile}"
  key_name                    = "${var.ssh_deployer_key}"
  ebs_device_name             = "${var.ebs_device_name}"
  ebs_volume_type             = "${var.ebs_volume_type}"
  ebs_volume_size             = "${var.ebs_volume_size}"
  ebs_encrypted               = "${var.ebs_encrypted}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  security_groups             = ["${local.instance_security_groups}"]
  user_data                   = "${data.template_file.user_data.rendered}"

}

############################################
# CREATE AUTO SCALING GROUP
############################################

module "auto_scale" {
  source               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//autoscaling//group//default"
  asg_name             = "${local.common_name}"
  subnet_ids           = ["${local.private_subnet_ids}"]
  asg_min              = "${var.asg_min}"
  asg_max              = "${var.asg_max}"
  asg_desired          = "${var.asg_desired}"
  launch_configuration = "${module.launch_cfg.launch_name}"
  tags                 = "${var.tags}"
}

############################################
# UPLOAD TO S3
############################################


# resource "aws_s3_bucket_object" "nginx_bucket_object" {
#   key    = "${local.common_name}/config/nginx.conf"
#   bucket = "${local.config_bucket}"
#   source = "./templates/nginx.conf"
#   etag   = "${md5(file("./templates/nginx.conf"))}"
# }
