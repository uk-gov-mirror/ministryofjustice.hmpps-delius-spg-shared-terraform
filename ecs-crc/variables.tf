# region
variable "region" {}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}


variable "s3_bucket_config" {}


variable "asg_instance_type_crc" {default = "t2.small"}
variable "cloudwatch_log_retention" {}


variable SPG_CRC_HOST_TYPE {}

variable SPG_GENERIC_BUILD_INV_DIR {}


variable SPG_CRC_JAVA_MAX_MEM {}
variable SPG_ENVIRONMENT_CODE {}
variable SPG_ENVIRONMENT_CN {}

variable SPG_DELIUS_MQ_URL {}
variable SPG_GATEWAY_MQ_URL {}

variable SPG_DOCUMENT_REST_SERVICE_ADMIN_URL {}
variable SPG_DOCUMENT_REST_SERVICE_PUBLIC_URL {}

variable SPG_ISO_FQDN {}
variable SPG_MPX_FQDN {}
variable SPG_CRC_FQDN {}

variable bastion_inventory {}


variable spg_crc_asg_desired {
  default="1"
}

variable spg_crc_asg_max {
  default="1"
}
variable spg_crc_asg_min {
  default="1"
}


variable spg_crc_service_desired_count {
  #1 = assumes desired ecs memory = max
  default="1"
}

variable spg_crc_ecs_memory {}


variable image_url {
  default = "895523100917.dkr.ecr.eu-west-2.amazonaws.com/hmpps/spg"
}

variable image_version {
  default = "latest"
}


variable "tags" {
  type = "map"
}

variable PO_SPG_CONFIGURATION {
  description ="map of PO configs"
  type="map"
}

variable "esc_container_stop_timeout" {
  default = "310s"
}

variable "deployment_minimum_healthy_percent_crc" {
  default = "100"

  //default as 0 to ensure ECS task deployments are always affected (crc is nearly always only 1 server)
  //there is no important data / processes to preserve as only MTS in test use crc and deployments are always scheduled
}