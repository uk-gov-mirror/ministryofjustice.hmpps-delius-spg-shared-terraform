# region
variable "region" {}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}


variable "s3_bucket_config" {}
variable "spg_build_inv_dir" {}

variable "asg_instance_type_iso" {default = "t2.small"}
variable "cloudwatch_log_retention" {}



variable SPG_GENERIC_BUILD_INV_DIR {}


variable SPG_ISO_JAVA_MAX_MEM {}


variable SPG_DELIUS_MQ_URL {}
variable SPG_GATEWAY_MQ_URL {}

variable SPG_DOCUMENT_REST_SERVICE_ADMIN_URL {}
variable SPG_DOCUMENT_REST_SERVICE_PUBLIC_URL {}

variable SPG_ISO_FQDN {}
variable SPG_MPX_FQDN {}
variable SPG_CRC_FQDN {}
variable SPG_ENVIRONMENT_CODE {}
variable SPG_ISO_HOST_TYPE {}


variable spg_iso_ecs_memory {}

//variable spg_iso_ecs_cpu_units {
//  default="256"
//}


variable "tags" {
  type = "map"
}

