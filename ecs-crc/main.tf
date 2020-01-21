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
  app_submodule = "crc"
  container_name = "${local.app_name}-${local.app_submodule}"
  application_endpoint = "${local.app_hostnames["external"]}"
  environment_identifier = "${data.terraform_remote_state.common.environment_identifier}"

  ########################################################################################################
  #Network common (protocol needs to match between front end and back end)
  ########################################################################################################
  backend_app_port = "9001"

  backend_app_protocol = "HTTP"

  ########################################################################################################
  #Target group and listeners
  ########################################################################################################
  vpc_id = "${data.terraform_remote_state.common.vpc_id}"

  target_type = "instance"

  ########################################################################################################
  #Classic Loadbalancer
  ########################################################################################################
  access_logs_bucket = "${data.terraform_remote_state.common.common_s3_lb_logs_bucket}"

  private_subnet_ids = [
    "${data.terraform_remote_state.common.private_subnet_ids}"]
  public_subnet_ids = [
    "${data.terraform_remote_state.common.public_subnet_ids}"]

  connection_draining = false
  connection_draining_timeout = 300

  backend_timeout        = "60"
  external_domain        = "${data.terraform_remote_state.common.external_domain}"
  public_zone_id         = "${data.terraform_remote_state.common.public_zone_id}"

  strategic_external_domain        = "${data.terraform_remote_state.common.strategic_external_domain}"
  strategic_public_zone_id         = "${data.terraform_remote_state.common.strategic_public_zone_id}"



  loadbalancer_security_groups = [
    "${data.terraform_remote_state.security-groups-and-rules.crc_internal_loadbalancer_sg_id}",
    "${data.terraform_remote_state.security-groups-and-rules.external_9001_from_vpc_public_ips_sg_id}",
    "${data.terraform_remote_state.vpc-security-groups.sg_ssh_bastion_in_id}"
    ]

  listener = [
//    {
//      instance_port = "61616"
//      instance_protocol = "TCP"
//      lb_port = "61616"
//      lb_protocol = "TCP"
//    },
//    {
//      instance_port = "8181"
//      instance_protocol = "HTTP"
//      lb_port = "8181"
//      lb_protocol = "HTTP"
//    },
//    {
//      instance_port = "8989"
//      instance_protocol = "HTTP"
//      lb_port = "8989"
//      lb_protocol = "HTTP"
//    },
    {
      instance_port = "9001"
      instance_protocol = "TCP"
      lb_port = "9001"
      lb_protocol = "TCP"
    },
    {
      instance_port = "2222"
      instance_protocol = "TCP"
      lb_port = "2222"
      lb_protocol = "TCP"
    },
  ]

  health_check_elb = [
    {
#      target = "HTTP:8181/cxf/"
      target = "TCP:9001"
      interval = 60
      healthy_threshold = 2

      #set to 10 to allow spg 10 mins to spin up
      unhealthy_threshold = 10
      timeout = 5
    },
  ]


  health_check_tg = [
    {
      protocol = "HTTP"
      path = "/cxf/"
      port = 8181
      interval = 30
      matcher = "200"
      healthy_threshold = 2
      #set to 10 to allow spg 10 mins to spin up (can be reduced once sm is pre installed on docker)
      unhealthy_threshold = 10
    },
  ]


  ########################################################################################################
  #                                   ECS service
  ########################################################################################################

  ########################################################################################################
  #ecs asg
  ########################################################################################################

  asg_desired = "${var.spg_crc_asg_desired}"
  asg_max = "${var.spg_crc_asg_max}"
  asg_min = "${var.spg_crc_asg_min}"


  ########################################################################################################
  #ecs service - app service
  ########################################################################################################
  ecs_service_role = "${data.terraform_remote_state.iam.iam_role_crc_int_ecs_role_arn}"
  service_desired_count = "${var.spg_crc_service_desired_count}"
//  sg_map_ids = "${data.terraform_remote_state.common.sg_map_ids}"
  instance_security_groups = [
    "${data.terraform_remote_state.vpc-security-groups.sg_ssh_bastion_in_id}",
    "${data.terraform_remote_state.security-groups-and-rules.spg_common_outbound_sg_id}",
    "${data.terraform_remote_state.security-groups-and-rules.crc_internal_instance_sg_id}",
    "${data.terraform_remote_state.security-groups-and-rules.crc_internal_loadbalancer_sg_id}",

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
  instance_profile = "${data.terraform_remote_state.iam.iam_policy_crc_int_app_instance_profile_name}"
  instance_type = "${var.asg_instance_type_crc}"
  ssh_deployer_key = "${data.terraform_remote_state.common.common_ssh_deployer_key}"
  associate_public_ip_address = false

  ########################################################################################################
  #ecs task definition
  ########################################################################################################

  image_url             = "${var.image_url}"
  image_version         = "${var.image_version}"
  ecs_memory    = "${var.spg_crc_ecs_memory}"
  #regular config bucket - not sure what this is used for yet
  config-bucket = "${data.terraform_remote_state.common.common_s3-config-bucket}"
  #vars for docker app
  #s3 bucket for ANISBLE jobs (derived from env properties
  s3_bucket_config = "${var.s3_bucket_config}"
  #vars for docker container
  kibana_host           = "NOTUSED(yet)"
  data_volume_host_path = "/opt/spg/servicemix/data"
  data_volume_name      = "spg"
  user_data             = "../user_data/spg_user_data.sh"

  SPG_HOST_TYPE         = "${var.SPG_CRC_HOST_TYPE}"
  SPG_GENERIC_BUILD_INV_DIR = "${var.SPG_GENERIC_BUILD_INV_DIR}"
  SPG_JAVA_MAX_MEM = "${var.SPG_CRC_JAVA_MAX_MEM}"
  SPG_ENVIRONMENT_CODE = "${var.SPG_ENVIRONMENT_CODE}"
  SPG_ENVIRONMENT_CN = "${var.SPG_ENVIRONMENT_CN}"
  SPG_AWS_REGION = "${data.terraform_remote_state.common.region}"
  SPG_DELIUS_MQ_URL = "${var.SPG_DELIUS_MQ_URL}"  //to be replaced with values from hmpps env configs (username / passes from SSM store)
  SPG_GATEWAY_MQ_URL = "${var.SPG_GATEWAY_MQ_URL}"  //to be replaced with values from hmpps env configs (username / passes from SSM store)
  SPG_DOCUMENT_REST_SERVICE_ADMIN_URL = "${var.SPG_DOCUMENT_REST_SERVICE_ADMIN_URL}"
  SPG_DOCUMENT_REST_SERVICE_PUBLIC_URL = "${var.SPG_DOCUMENT_REST_SERVICE_PUBLIC_URL}"
  SPG_ISO_FQDN = "${var.SPG_ISO_FQDN}"
  SPG_MPX_FQDN = "${var.SPG_MPX_FQDN}"
  SPG_CRC_FQDN = "${var.SPG_CRC_FQDN}"


  ########################################################################################################

########################################################################################################
#ecs service -  log group
########################################################################################################
  cloudwatch_log_retention = "${var.cloudwatch_log_retention}"
}