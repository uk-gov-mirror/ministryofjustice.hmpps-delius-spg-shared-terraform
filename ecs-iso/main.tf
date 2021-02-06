####################################################
# Locals
####################################################

locals {
  ########################################################################################################
  #Common (lots of duplication here, needs further refactoring)
  ########################################################################################################

  tags = merge(var.tags)

  short_environment_name   = data.terraform_remote_state.common.outputs.short_environment_name
  app_hostnames            = data.terraform_remote_state.common.outputs.app_hostnames
  project_name_abbreviated = data.terraform_remote_state.common.outputs.project_name_abbreviated

  hmpps_asset_name_prefix = data.terraform_remote_state.common.outputs.hmpps_asset_name_prefix
  common_name             = "${local.hmpps_asset_name_prefix}-${local.app_hostnames["external"]}-${local.app_submodule}"

  spg_app_name   = data.terraform_remote_state.common.outputs.spg_app_name
  app_name       = local.spg_app_name
  app_submodule  = "iso"
  container_name = "${local.app_name}-${local.app_submodule}"

  application_endpoint   = local.app_hostnames["external"]
  environment_identifier = data.terraform_remote_state.common.outputs.environment_identifier

  #for dns
  public_zone_id  = data.terraform_remote_state.common.outputs.public_zone_id
  external_domain = data.terraform_remote_state.common.outputs.external_domain

  strategic_external_domain = data.terraform_remote_state.common.outputs.strategic_external_domain
  strategic_public_zone_id  = data.terraform_remote_state.common.outputs.strategic_public_zone_id

  ########################################################################################################
  #Network common (protocol needs to match between front end and back end)
  ########################################################################################################
  backend_app_port = "9001"

  backend_app_protocol  = "TCP"
  frontend_app_port     = "9001"
  frontend_app_protocol = local.backend_app_protocol

  ########################################################################################################
  #Target group and listeners
  ########################################################################################################
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id

  target_type = "instance"

  #for haproxy, possibly just a tcp check would be better (on port 9001?)
  #for iso, needs to check on 8181 until certificates are working properly on 9001

  health_check = [
    {
      protocol          = "TCP"
      port              = 8181
      interval          = 30
      healthy_threshold = 10
      #set to 10 to allow spg 10 mins to spin up (can be reduced once sm is pre installed on docker)
      unhealthy_threshold = 10
      #path and matcher must be blank for TCP protocol (would be "/cxf/" and "200" respectively if was ALB healthcheck
      #path    = ""
      #matcher = ""
    },
  ]

  ########################################################################################################
  #Network Loadbalancer
  ########################################################################################################

  access_logs_bucket = data.terraform_remote_state.common.outputs.common_s3_lb_logs_bucket
  private_subnet_ids = data.terraform_remote_state.common.outputs.private_subnet_ids

  public_subnet_ids = data.terraform_remote_state.common.outputs.public_subnet_ids

  az_lb_eip_allocation_ids = [
    data.terraform_remote_state.persistent_eip.outputs.spg_az1_lb_eip.allocation_id,
    data.terraform_remote_state.persistent_eip.outputs.spg_az2_lb_eip.allocation_id,
    data.terraform_remote_state.persistent_eip.outputs.spg_az3_lb_eip.allocation_id,
  ]

  ########################################################################################################
  #                                   ECS service
  ########################################################################################################

  ########################################################################################################
  #ecs asg
  ########################################################################################################

  asg_desired = var.spg_iso_asg_desired
  asg_max     = var.spg_iso_asg_max
  asg_min     = var.spg_iso_asg_min

  ########################################################################################################
  #ecs service - app service
  ########################################################################################################
  ecs_service_role      = data.terraform_remote_state.iam.outputs.iam_role_iso_ext_ecs_role_arn
  service_desired_count = var.spg_iso_service_desired_count

  //  sg_map_ids = "${data.terraform_remote_state.common.sg_map_ids}"
  instance_security_groups = [
    data.terraform_remote_state.vpc-security-groups.outputs.sg_ssh_bastion_in_id,
    data.terraform_remote_state.security-groups-and-rules.outputs.spg_common_outbound_sg_id,
    data.terraform_remote_state.security-groups-and-rules.outputs.iso_external_instance_sg_id,
    data.terraform_remote_state.security-groups-and-rules.outputs.parent_orgs_spg_ingress_sg_id,
    data.terraform_remote_state.security-groups-and-rules.outputs.external_9001_from_vpc_public_ips_sg_id,
  ]

  ########################################################################################################
  #ecs service block device
  ########################################################################################################
  ebs_device_name = "/dev/xvdb"
  ebs_encrypted   = "true"
  ebs_volume_size = "150"
  ebs_volume_type = "standard"
  volume_size     = "150"

  ########################################################################################################
  #ecs launch config
  ########################################################################################################
  ami_id                      = data.aws_ami.amazon_ami.id
  instance_profile            = data.terraform_remote_state.iam.outputs.iam_policy_iso_ext_app_instance_profile_name
  instance_type               = var.asg_instance_type_iso
  ssh_deployer_key            = data.terraform_remote_state.common.outputs.common_ssh_deployer_key
  associate_public_ip_address = false

  ########################################################################################################
  #ecs task definition
  ########################################################################################################

  image_url     = var.image_url
  image_version = var.image_version
  ecs_memory    = var.spg_iso_ecs_memory

  #regular config bucket - not sure what this is used for yet
  #vars for docker app
  #s3 bucket for ANISBLE jobs (derived from env properties
  s3_bucket_config = var.s3_bucket_config

  #vars for docker container
  kibana_host           = "NOTUSED(yet)"
  data_volume_host_path = "/opt/spg/servicemix/data"
  data_volume_name      = "spg"
  user_data             = "../user_data/spg_user_data.sh"

  SPG_HOST_TYPE                        = var.SPG_ISO_HOST_TYPE
  SPG_GENERIC_BUILD_INV_DIR            = var.SPG_GENERIC_BUILD_INV_DIR
  SPG_JAVA_MAX_MEM                     = var.SPG_ISO_JAVA_MAX_MEM
  SPG_ENVIRONMENT_CODE                 = var.SPG_ENVIRONMENT_CODE
  SPG_ENVIRONMENT_CN                   = var.SPG_ENVIRONMENT_CN
  SPG_AWS_REGION                       = data.terraform_remote_state.common.outputs.region
  SPG_DELIUS_MQ_URL                    = var.SPG_DELIUS_MQ_URL  //to be replaced with values from hmpps env configs (username / passes from SSM store)
  SPG_GATEWAY_MQ_URL                   = var.SPG_GATEWAY_MQ_URL //to be replaced with values from hmpps env configs (username / passes from SSM store)
  SPG_DOCUMENT_REST_SERVICE_ADMIN_URL  = var.SPG_DOCUMENT_REST_SERVICE_ADMIN_URL
  SPG_DOCUMENT_REST_SERVICE_PUBLIC_URL = var.SPG_DOCUMENT_REST_SERVICE_PUBLIC_URL
  SPG_ISO_FQDN                         = var.SPG_ISO_FQDN
  SPG_MPX_FQDN                         = var.SPG_MPX_FQDN
  SPG_CRC_FQDN                         = var.SPG_CRC_FQDN

  ########################################################################################################

  ########################################################################################################
  #ecs service -  log group
  ########################################################################################################
  cloudwatch_log_retention = var.cloudwatch_log_retention
}

