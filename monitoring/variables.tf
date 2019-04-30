# region
variable "region" {}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}


//variable "s3_bucket_config" {}

//variable "region" {
//  description = "The AWS region"
//}
//
//variable "project_name" {
//  description = "The project name - vcms"
//}
//
//variable "environment_type" {
//  description = "The environment type - e.g. dev"
//}
//
//variable "remote_state_bucket_name" {
//  description = "Terraform remote state bucket name"
//}
//
variable "alarms_enabled" {
  type = "string"
  default="false"
}
//
//variable "lower_cpu_trigger" {
//  type = "string"
//}
//
//variable "upper_cpu_trigger" {
//  type = "string"
//}
//
//variable "db_storage" {
//  description = "The amount of storage allocated to the database, in GB"
//}
//
//variable "db_memory" {
//  description = "The amount of memory allocated to the database, in MB"
//}

variable "build_tag" {
  description = "Semantic version number"
  default ="0.0"

}

variable "tags" {
  type = "map"
  description = "Default tag set"
}
