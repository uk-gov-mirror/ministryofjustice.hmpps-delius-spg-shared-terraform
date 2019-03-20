terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region                                   = "${var.region}"
  version                                  = ">= 2.1.0"
  #2.1.0 needed for ecs elb graceperiod, is set in the local elb module
  #version                                  = "~> 1.16"
}



####################################################
# Locals
####################################################

locals {

#common (lots of duplication here, needs further refactoring)

  tags                                 = "${var.tags}"
    short_environment_name               = "${data.terraform_remote_state.common.short_environment_name}"
    common_name                         = "${local.short_environment_name}-${local.app_hostnames["external"]}-${local.app_submodule}"
    app_hostnames                        = "${data.terraform_remote_state.common.app_hostnames}"
    spg_app_name                         = "${data.terraform_remote_state.common.spg_app_name}"
    app_name                             = "${local.spg_app_name}"
    app_submodule                        = "iso"
    application_endpoint                 = "${local.app_hostnames["external"]}"
    environment_identifier               = "${data.terraform_remote_state.common.environment_identifier}"

   #network common (protocol needs to match between front end and back end)
    backend_app_port                     = "9001"
    backend_app_protocol                 = "TCP"
    frontend_app_port                     = "9001"
    frontend_app_protocol                 = "${local.backend_app_protocol}"



####################################################

#target group and listeners
  vpc_id                               = "${data.terraform_remote_state.common.vpc_id}"
  target_type                          = "instance"


####################################################

#loadbalancer
  access_logs_bucket                   = "${data.terraform_remote_state.common.common_s3_lb_logs_bucket}"

  private_subnet_ids                   = ["${data.terraform_remote_state.common.private_subnet_ids}"]
  public_subnet_ids                    = ["${data.terraform_remote_state.common.public_subnet_ids}"]

  az_lb_eip_allocation_ids                                  = [
    "${data.terraform_remote_state.persistent_spg.spg_az1_lb_eip.allocation_id}",
    "${data.terraform_remote_state.persistent_spg.spg_az2_lb_eip.allocation_id}",
    "${data.terraform_remote_state.persistent_spg.spg_az3_lb_eip.allocation_id}"
  ]


  #dns
  public_zone_id                       = "${data.terraform_remote_state.common.public_zone_id}"


####################################################
#ecs service

  #####################
  #ecs service -  log group
  cloudwatch_log_retention             = "${var.cloudwatch_log_retention}"

  #####################
  #ecs service - app service
  ecs_service_role                     = "${data.terraform_remote_state.iam.iam_role_ext_ecs_role_arn}"
  service_desired_count                = "2"

  sg_map_ids                           = "${data.terraform_remote_state.common.security_group_map_ids}"

  instance_security_groups             = [
    "${local.sg_map_ids["external_inst_sg_id"]}", //for iso
    "${local.sg_map_ids["internal_inst_sg_id"]}", //for mpx
    "${local.sg_map_ids["bastion_in_sg_id"]}",
    "${local.sg_map_ids["outbound_sg_id"]}",
  ]



  #####################
  #ecs service block device
  ebs_device_name                      = "/dev/xvdb"
  ebs_encrypted                        = "true"
  volume_size                          = "50"
  ebs_volume_size                      = "50"
  ebs_volume_type                      = "standard"

  #####################
  #ecs launch config
  ami_id                               = "${data.aws_ami.amazon_ami.id}"
  instance_type                        = "t2.medium"
  instance_profile                     = "${data.terraform_remote_state.iam.iam_policy_ext_app_instance_profile_name}"

  ssh_deployer_key                     = "${data.terraform_remote_state.common.common_ssh_deployer_key}"
  associate_public_ip_address          = true

  #####################
  #ecs asg
  asg_desired                          = "1"
  asg_max                              = "3"
  asg_min                              = "1"


  #####################
  #ecs task definition
  image_url                            = "${data.terraform_remote_state.ecr.ecr_repository_url}"
  image_version                        = "latest"
  backend_ecs_cpu_units                = "256"
  backend_ecs_memory                   = "2048"


    #regular config bucket - not sure what this is used for yet
    config-bucket                        = "${data.terraform_remote_state.common.common_s3-config-bucket}"

    #vars for docker app
    #s3 bucket for ANISBLE jobs (derived from env properties
    s3_bucket_config                     = "${var.s3_bucket_config}"
    spg_build_inv_dir                    = "${var.spg_build_inv_dir}"

    #vars for docker container
    kibana_host                          = "NOTUSED(yet)"
    data_volume_host_path                = "/opt/spg"
    data_volume_name                      ="spg"



  ####################







}
//
//####################################################
//# Application Specific
//####################################################
//module "ecs-iso" {
//  source                                                          = "../modules/ecs-nlb"
//  app_name                                                        = "${local.spg_app_name}"
//  app_submodule                                                   = "${local.app_submodule}"
//  certificate_arn                                                 = ["${local.certificate_arn}"]
//  image_url                                                       = "${local.image_url}"
//  image_version                                                   = "${local.image_version}"
//  short_environment_name                                          = "${local.short_environment_name}"
//  environment_identifier                                          = "${local.environment_identifier}"
//  public_subnet_ids                                               = ["${local.public_subnet_ids}"]
//  private_subnet_ids                                              = ["${local.private_subnet_ids}"]
//  tags                                                            = "${var.tags}"
//  instance_security_groups                                        = ["${local.instance_security_groups}"]
//  ext_lb_security_groups                                          = ["${local.ext_lb_security_groups}"]
//  int_lb_security_groups                                          = ["${local.int_lb_security_groups}"]
//  vpc_id                                                          = "${local.vpc_id}"
//  config_bucket                                                   = "${local.config-bucket}"
//  access_logs_bucket                                              = "${local.access_logs_bucket}"
//  public_zone_id                                                  = "${local.public_zone_id}"
//  external_domain                                                 = "${local.external_domain}"
//  internal_domain                                                 = "${local.internal_domain}"
//  internal_or_external_label                                      = "int"
//  alb_backend_port                                                = "9001"
//  alb_http_port                                                   = "80"
//  alb_https_port                                                  = "443"
//  deregistration_delay                                            = "90"
//  backend_app_port                                                = "9001"
//  backend_app_protocol                                            = "TCP"
//  backend_app_template_file                                       = "template.json"
//  backend_check_app_path                                          = "/cxf/"
//  backend_check_interval                                          = "30"
//  backend_ecs_cpu_units                                           = "256"
//  backend_ecs_desired_count                                       = "1"
//  backend_ecs_memory                                              = "2048"
//  backend_healthy_threshold                                       = "2"
//  backend_maxConnections                                          = "500"
//  backend_maxConnectionsPerRoute                                  = "200"
//  backend_return_code                                             = "200,302"
//  backend_timeout                                                 = "60"
//  backend_timeoutInSeconds                                        = "60"
//  backend_timeoutRetries                                          = "10"
//  backend_unhealthy_threshold                                     = "10"
//  target_type                                                     = "instance"
//  cloudwatch_log_retention                                        = "${local.cloudwatch_log_retention}"
//  keys_dir                                                        = "/opt/spg"
//  kibana_host                                                     = "${local.monitoring_server_internal_url}"
//  app_hostnames                                                   = "${local.app_hostnames}"
//  region                                                          = "${local.region}"
//  ecs_service_role                                                = "${local.ecs_service_role}"
//  service_desired_count                                           = "${local.service_desired_count}"
//  user_data                                                       = "../user_data/spg_user_data.sh"
//  volume_size                                                     = "50"
//  ebs_device_name                                                 = "/dev/xvdb"
//  ebs_volume_type                                                 = "standard"
//  ebs_volume_size                                                 = "50"
//  ebs_encrypted                                                   = "true"
//  instance_type                                                   = "t2.medium"
//  asg_desired                                                     = "1"
//  asg_max                                                         = "3"
//  asg_min                                                         = "1"
//  associate_public_ip_address                                     = true
//  ami_id                                                          = "${local.ami_id}"
//  instance_profile                                                = "${local.instance_profile}"
//  ssh_deployer_key                                                = "${local.ssh_deployer_key}"
//  s3_bucket_config                                                = "${var.s3_bucket_config}"
//  spg_build_inv_dir                                               = "${var.spg_build_inv_dir}"
////  health_check                                                    = "${local.health_check}"
////  listener                                                        = "${local.listener}"
//  az_lb_eip_allocation_ids                                        = "${local.az_lb_eip_allocation_ids}"
//
//
//}





//no longer used
//  account_id                           = "${data.terraform_remote_state.common.common_account_id}"
//  alb_backend_port                     = "9001"
//  alb_http_port                        = "80"
//  alb_https_port                       = "443"
//

//  az_lb_eip_allocation_ids             = "${local.az_lb_eip_allocation_ids}"

//  backend_app_template_file            = "template.json"

//
//  backend_ecs_desired_count            = "1"
//
//  backend_healthy_threshold            = "2"
//  backend_maxConnections               = "500"
//  backend_maxConnectionsPerRoute       = "200"
//  backend_return_code                  = "200,302"
//  backend_timeout                      = "60"
//  backend_timeoutInSeconds             = "60"
//  backend_timeoutRetries               = "10"
//  backend_unhealthy_threshold          = "10"
//  certificate_arn                      = ["${data.aws_acm_certificate.cert.arn}"]
//  cidr_block                           = "${data.terraform_remote_state.common.vpc_cidr_block}"
//
//  deregistration_delay                 = "90"

//
//  ext_lb_security_groups               = ["${data.terraform_remote_state.security-groups.security_groups_sg_external_lb_id}"]
//  external_domain                      = "${data.terraform_remote_state.common.external_domain}"
//  health_check                         = "${local.health_check}"
//
//
//
//  instance_security_groups             = ["${local.instance_security_groups}"]
//
//  int_lb_security_groups               = ["${data.terraform_remote_state.security-groups.security_groups_sg_internal_lb_id}"]
//  internal_domain                      = "${data.terraform_remote_state.common.internal_domain}"
//  internal_or_external_label           = "int"
//  listener                             = "${local.listener}"
//  monitoring_server_internal_url       = "tmpdoesnotexist"                                                                    # "${data.terraform_remote_state.common.monitoring_server_internal_url}"
//  private_subnet_map                   = "${data.terraform_remote_state.common.private_subnet_map}"
//  private_zone_id                      = "${data.terraform_remote_state.common.private_zone_id}"
//  public_cidr_block                    = ["${data.terraform_remote_state.common.db_cidr_block}"]

//
//  region                               = "${var.region}"
//  region                               = "${local.region}"
//
//
//
//
//
//
//
//  user_data                            = "../user_data/spg_user_data.sh"
//
//
//
