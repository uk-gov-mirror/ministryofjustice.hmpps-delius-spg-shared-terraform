# region
variable "region" {}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}


variable "s3_bucket_config" {}


variable "asg_instance_type_mpx" {default = "t2.medium"}
variable "cloudwatch_log_retention" {}





variable SPG_MPX_HOST_TYPE {}
variable SPG_GENERIC_BUILD_INV_DIR {}
variable SPG_MPX_JAVA_MAX_MEM {
  default="1500"
}
variable SPG_ENVIRONMENT_CODE {}
variable SPG_ENVIRONMENT_CN {}


variable SPG_DELIUS_MQ_URL {}

variable SPG_GATEWAY_MQ_URL {
  default     = "localhost:61616"
  description = "SPG messaging broker url"
}

variable SPG_GATEWAY_MQ_URL_SOURCE {
  default     = "data"
  description = "var -> variable.SPG_GATEWAY_MQ_URL | data -> data.terraform.remote_state.amazonmq.amazon_mq_broker_connect_url"
}

variable SPG_DOCUMENT_REST_SERVICE_ADMIN_URL {}
variable SPG_DOCUMENT_REST_SERVICE_PUBLIC_URL {}

variable SPG_ISO_FQDN {}
variable SPG_MPX_FQDN {}
variable SPG_CRC_FQDN {}


variable spg_mpx_asg_desired {
  default="1"
}

variable spg_mpx_asg_max {
  default="1"
}
variable spg_mpx_asg_min {
  default="1"
}

variable spg_mpx_service_desired_count {
  #1 = assumes desired ecs memory = max
  default="1"
}

variable spg_mpx_ecs_memory {
  default="2048"
}

//variable spg_mpx_ecs_cpu_units {
//}


variable image_url {
  default = "895523100917.dkr.ecr.eu-west-2.amazonaws.com/hmpps/spg"
}

variable image_version {
  default = "latest"
}

variable bastion_inventory {}


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

variable "deployment_minimum_healthy_percent" {
  default = "50"
}

variable "sub-application1" {
  type="map"
  default = {
    "sub-application" = "spg"
  }
}