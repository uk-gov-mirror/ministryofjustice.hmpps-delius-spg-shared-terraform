terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = ">= 2.1.0"

  #2.1.0 needed for ecs elb graceperiod, is set in the local elb module
  #version = "~> 1.16"
}

####################################################
# Locals
####################################################

locals {
  ########################################################################################################
  #Common (lots of duplication here, needs further refactoring)
  ########################################################################################################
  tags = "${var.tags}"

  short_environment_name = "${data.terraform_remote_state.common.short_environment_name}"
  app_hostnames = "${data.terraform_remote_state.common.app_hostnames}"
  project_name_abbreviated = "${data.terraform_remote_state.common.project_name_abbreviated}"

  hmpps_asset_name_prefix = "${data.terraform_remote_state.common.hmpps_asset_name_prefix}"
  common_name = "${local.hmpps_asset_name_prefix}-${local.app_hostnames["external"]}-${local.app_submodule}"

  spg_app_name = "${data.terraform_remote_state.common.spg_app_name}"
  app_name = "${local.spg_app_name}"
  app_submodule = "iso"
  application_endpoint = "${local.app_hostnames["external"]}"
  environment_identifier = "${data.terraform_remote_state.common.environment_identifier}"

  ########################################################################################################
  #Network common (protocol needs to match between front end and back end)
  ########################################################################################################
  backend_app_port = "9001"

  backend_app_protocol = "TCP"
  frontend_app_port = "9001"
  frontend_app_protocol = "${local.backend_app_protocol}"

  ########################################################################################################
  #Target group and listeners
  ########################################################################################################
  vpc_id = "${data.terraform_remote_state.common.vpc_id}"

  target_type = "instance"

  #for haproxy, possibly just a tcp check would be better (on port 9001?)
  #for iso, needs to check on 8181 until certificates are working properly on 9001

  health_check = [
    {
      protocol = "TCP"
      port = 8181
      interval = 30
      healthy_threshold = 10
      #set to 10 to allow spg 10 mins to spin up (can be reduced once sm is pre installed on docker)
      unhealthy_threshold = 10
      #path and matcher must be blank for TCP protocol (would be "/cxf/" and "200" respectively if was ALB healthcheck
      path = ""
      matcher = ""
    },
  ]

  ########################################################################################################
  #Network Loadbalancer
  ########################################################################################################

  access_logs_bucket = "${data.terraform_remote_state.common.common_s3_lb_logs_bucket}"
  private_subnet_ids = [
    "${data.terraform_remote_state.common.private_subnet_ids}"]
  public_subnet_ids = [
    "${data.terraform_remote_state.common.public_subnet_ids}"]
  az_lb_eip_allocation_ids = [
    "${data.terraform_remote_state.persistent_eip.spg_az1_lb_eip.allocation_id}",
    "${data.terraform_remote_state.persistent_eip.spg_az2_lb_eip.allocation_id}",
    "${data.terraform_remote_state.persistent_eip.spg_az3_lb_eip.allocation_id}",
  ]

  #for dns
  public_zone_id = "${data.terraform_remote_state.common.public_zone_id}"

  ########################################################################################################
  #                                   ECS service
  ########################################################################################################

  ########################################################################################################
  #ecs asg
  ########################################################################################################

  asg_desired = "1"
  asg_max = "3"
  asg_min = "1"


  ########################################################################################################
  #ecs service - app service
  ########################################################################################################
  ecs_service_role = "${data.terraform_remote_state.iam.iam_role_ext_ecs_role_arn}"
  service_desired_count = "1"
  sg_map_ids = "${data.terraform_remote_state.common.sg_map_ids}"
  instance_security_groups = [
    "${local.sg_map_ids["external_inst_sg_id"]}",
    "${local.sg_map_ids["bastion_in_sg_id"]}",
    "${local.sg_map_ids["outbound_sg_id"]}",
  ]
  ########################################################################################################
  #ecs service block device
  ########################################################################################################
  ebs_device_name = "/dev/xvdb"
  ebs_encrypted = "true"
  ebs_volume_size = "50"
  ebs_volume_type = "standard"
  volume_size = "50"
  ########################################################################################################
  #ecs launch config
  ########################################################################################################
  ami_id = "${data.aws_ami.amazon_ami.id}"
  instance_profile = "${data.terraform_remote_state.iam.iam_policy_ext_app_instance_profile_name}"
  instance_type = "${var.asg_instance_type_iso}"
  ssh_deployer_key = "${data.terraform_remote_state.common.common_ssh_deployer_key}"
  associate_public_ip_address = true

  ########################################################################################################
  #ecs task definition
  ########################################################################################################

  image_url = "${data.terraform_remote_state.ecr.ecr_repository_url}"
  image_version = "latest"
  backend_ecs_cpu_units = "256"
  backend_ecs_memory = "2048"
  #regular config bucket - not sure what this is used for yet
  config-bucket = "${data.terraform_remote_state.common.common_s3-config-bucket}"
  #vars for docker app
  #s3 bucket for ANISBLE jobs (derived from env properties
  s3_bucket_config = "${var.s3_bucket_config}"
  spg_build_inv_dir = "${var.spg_build_inv_dir}"
  #vars for docker container
  kibana_host = "NOTUSED(yet)"
  data_volume_host_path = "/opt/spg"
  data_volume_name = "spg"
  user_data = "../user_data/spg_user_data.sh"
  ########################################################################################################


  ########################################################################################################
  #ecs service -  log group
  ########################################################################################################
  cloudwatch_log_retention = "${var.cloudwatch_log_retention}"
}