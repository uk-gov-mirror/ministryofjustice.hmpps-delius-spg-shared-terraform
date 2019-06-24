# region
variable "region" {}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}


variable "s3_bucket_config" {}
variable "spg_build_inv_dir" {}

variable "asg_instance_type_mpx" {default = "t2.medium"}
variable "cloudwatch_log_retention" {}


variable SPG_GENERIC_BUILD_INV_DIR {}


variable SPG_MPX_JAVA_MAX_MEM {
  default="1500"
}


variable SPG_DELIUS_MQ_URL {}
variable SPG_GATEWAY_MQ_URL {}

variable SPG_DOCUMENT_REST_SERVICE_ADMIN_URL {}
variable SPG_DOCUMENT_REST_SERVICE_PUBLIC_URL {}

variable SPG_ISO_FQDN {}
variable SPG_MPX_FQDN {}
variable SPG_CRC_FQDN {}



#typically these values are
#https://alfresco.{{ environment_cn }}/alfresco/service/admin-spg
#https://alfresco.{{ environment_cn }}/alfresco/service/noms-spg




#spg_iso_fqdn: "spgw-ext.{{ environment_cn }}"
#spg_crc_fqdn: "spgw-crc-int.{{ environment_cn }}"



variable spg_mpx_ecs_memory {
  default="2048"
}

variable spg_mpx_ecs_cpu_units {
  default="256"
}




variable "tags" {
  type = "map"
}

