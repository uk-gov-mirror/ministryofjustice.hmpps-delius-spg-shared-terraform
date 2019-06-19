# region
variable "region" {}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}


variable "s3_bucket_config" {}
variable "spg_build_inv_dir" {}

variable "asg_instance_type_mpx" {default = "t2.medium"}
variable "cloudwatch_log_retention" {}


variable SPG_MPX_JAVA_MAX_MEM {
  default="1500"
}


variable SPG_DELIUS_MQ_URL {
}


variable SPG_GATEWAY_MQ_URL {

}

variable spg_mpx_ecs_memory {
  default="2048"
}



variable "tags" {
  type = "map"
}

