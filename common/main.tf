terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
}


####################################################
# Locals
####################################################

locals {
  spg_app_name                   = "${var.spg_app_name}"
  environment_identifier         = "${var.environment_identifier}"
  short_environment_identifier   = "${var.short_environment_identifier}"

  short_environment_name         = "${var.short_environment_name}"
  project_name_abbreviated       = "${var.project_name_abbreviated}"

  common_name                    = "${var.short_environment_name}-${var.spg_app_name}"
  full_common_name               = "${var.environment_identifier}-${var.spg_app_name}"



  app_hostnames = {
    internal = "${var.spg_app_name}-int"
    external = "${var.spg_app_name}"
  }

  vpc_id                         = "${data.terraform_remote_state.vpc.vpc_id}"
  cidr_block                     = "${data.terraform_remote_state.vpc.vpc_cidr_block}"
  allowed_cidr_block             = ["${data.terraform_remote_state.vpc.vpc_cidr_block}"]
  internal_domain                = "${data.terraform_remote_state.vpc.private_zone_name}"
  private_zone_id                = "${data.terraform_remote_state.vpc.private_zone_id}"
  external_domain                = "${data.terraform_remote_state.vpc.public_zone_name}"
  public_zone_id                 = "${data.terraform_remote_state.vpc.public_zone_id}"
  lb_account_id                  = "${var.lb_account_id}"
  region                         = "${var.region}"
  role_arn                       = "${var.role_arn}"
  remote_state_bucket_name       = "${var.remote_state_bucket_name}"
  s3_lb_policy_file              = "../policies/s3_alb_policy.json"
#  monitoring_server_external_url = "${data.terraform_remote_state.monitor.monitoring_server_external_url}"
#  monitoring_server_internal_url = "${data.terraform_remote_state.monitor.monitoring_server_internal_url}"
#  monitoring_server_client_sg_id = "${data.terraform_remote_state.monitor.monitoring_server_client_sg_id}"
  ssh_deployer_key               = "${data.terraform_remote_state.vpc.ssh_deployer_key}"
  eng_root_arn                   = "${var.eng_root_arn}"


#security_group_map_ids
  sg_map_ids            = {
    external_inst_sg_id = "${data.terraform_remote_state.security-groups.sg_spg_nginx_in}"
    internal_inst_sg_id = "${data.terraform_remote_state.security-groups.sg_spg_api_in}"
    external_lb_sg_id   = "${data.terraform_remote_state.security-groups.sg_spg_external_lb_in}"
    internal_lb_sg_id   = "${data.terraform_remote_state.security-groups.sg_spg_internal_lb_in}"
    bastion_in_sg_id    = "${data.terraform_remote_state.security-groups.sg_ssh_bastion_in_id}"
    outbound_sg_id      = "${aws_security_group.vpc-sg-outbound.id}"
    //    jms_in_sg_id        = "${data.terraform_remote_state.security-groups.sg_spg_jms_in_sg_id}"
    #db_sg_id            = "${data.terraform_remote_state.security-groups.sg_spg_db_in}"
  }



  private_subnet_map = {
    az1 = "${data.terraform_remote_state.vpc.vpc_private-subnet-az1}"
    az2 = "${data.terraform_remote_state.vpc.vpc_private-subnet-az2}"
    az3 = "${data.terraform_remote_state.vpc.vpc_private-subnet-az3}"
  }

  public_cidr_block = [
    "${data.terraform_remote_state.vpc.vpc_public-subnet-az1-cidr_block}",
    "${data.terraform_remote_state.vpc.vpc_public-subnet-az2-cidr_block}",
    "${data.terraform_remote_state.vpc.vpc_public-subnet-az3-cidr_block}",
  ]

  private_cidr_block = [
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az1-cidr_block}",
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az2-cidr_block}",
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az3-cidr_block}",
  ]

  db_cidr_block = [
    "${data.terraform_remote_state.vpc.vpc_db-subnet-az1-cidr_block}",
    "${data.terraform_remote_state.vpc.vpc_db-subnet-az2-cidr_block}",
    "${data.terraform_remote_state.vpc.vpc_db-subnet-az3-cidr_block}",
  ]

  db_subnet_ids = [
    "${data.terraform_remote_state.vpc.vpc_db-subnet-az1}",
    "${data.terraform_remote_state.vpc.vpc_db-subnet-az2}",
    "${data.terraform_remote_state.vpc.vpc_db-subnet-az3}",
  ]


  tags            = "${var.tags}"

}




