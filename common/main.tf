
####################################################
# Locals
####################################################

locals {
  spg_app_name           = var.spg_app_name
  environment_identifier = var.environment_identifier

  #as of 11/04/2019 in env/common/common.properties, env name also has project name in it
  #export TG_SHORT_ENVIRONMENT_NAME="${TG_PROJECT_NAME_ABBREVIATED}-${TG_ENVIRONMENT_TYPE}"

  short_environment_name   = var.short_environment_name
  project_name_abbreviated = var.project_name_abbreviated
  common_name              = "${var.short_environment_name}-${var.spg_app_name}"
  full_common_name         = "${var.environment_identifier}-${var.spg_app_name}"
  hmpps_asset_name_prefix  = var.short_environment_name
  app_hostnames = {
    internal = "${var.spg_app_name}-int"
    external = var.spg_app_name
  }
  vpc_id                   = data.terraform_remote_state.vpc.outputs.vpc_id
  cidr_block               = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
  allowed_cidr_block       = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
  internal_domain          = data.terraform_remote_state.vpc.outputs.private_zone_name
  private_zone_id          = data.terraform_remote_state.vpc.outputs.private_zone_id
  external_domain          = data.terraform_remote_state.vpc.outputs.public_zone_name
  public_zone_id           = data.terraform_remote_state.vpc.outputs.public_zone_id
  lb_account_id            = var.lb_account_id
  region                   = var.region
  role_arn                 = var.role_arn
  remote_state_bucket_name = var.remote_state_bucket_name
  s3_lb_policy_file        = "../policies/s3_alb_policy.json"

  #  monitoring_server_external_url = "${data.terraform_remote_state.monitor.monitoring_server_external_url}"
  #  monitoring_server_internal_url = "${data.terraform_remote_state.monitor.monitoring_server_internal_url}"
  #  monitoring_server_client_sg_id = "${data.terraform_remote_state.monitor.monitoring_server_client_sg_id}"
  ssh_deployer_key = data.terraform_remote_state.vpc.outputs.ssh_deployer_key

  #security_group_map_ids
  //  sg_map_ids            = {
  //    #deprecated
  ////    external_inst_sg_id = "${data.terraform_remote_state.security-groups.sg_spg_nginx_in}"
  ////    internal_inst_sg_id = "${data.terraform_remote_state.security-groups.sg_spg_api_in}"
  ////    external_lb_sg_id   = "${data.terraform_remote_state.security-groups.sg_spg_external_lb_in}"
  ////    internal_lb_sg_id   = "${data.terraform_remote_state.security-groups.sg_spg_internal_lb_in}"
  //
  //    #retain
  ////    outbound_sg_id      = "${aws_security_group.vpc-sg-outbound.id}"
  //    bastion_in_sg_id    = "${data.terraform_remote_state.security-groups.sg_ssh_bastion_in_id}"
  //  }
  //
  //  amazonmq_inst_sg_id = "${data.terraform_remote_state.security-groups.sg_amazonmq_in}"

  private_subnet_map = {
    az1 = data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az1
    az2 = data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az2
    az3 = data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az3
  }
  public_cidr_block = [
    data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az1-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az2-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_public-subnet-az3-cidr_block,
  ]
  private_cidr_block = [
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az1-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az2-cidr_block,
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az3-cidr_block,
  ]
  tags = var.tags
}

