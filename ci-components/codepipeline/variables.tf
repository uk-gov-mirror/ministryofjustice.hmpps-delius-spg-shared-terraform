variable "region" {
  description = "The AWS region."
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_name" {
  type = string
}

variable "branch_name" {
  type = string
}

variable "sub_project_crc" {
  type = string
}

variable "sub_project_mpx" {
  type = string
}

variable "sub_project_iso" {
  type = string
}

variable "sub_project_elk_domains" {
  type = string
}

variable "sub_project_elk_service" {
  type = string
}

variable "sub_project_iam" {
  type = string
}

variable "sub_project_iam_spg_app_policies" {
  type = string
}

variable "sub_project_kms_certificates_spg" {
  type = string
}

variable "sub_project_security_groups_and_rules" {
  type = string
}

variable "sub_project_monitoring" {
  type = string
}

variable "sub_project_amazonmq" {
  type = string
}

variable "sub_project_common" {
  type = string
}

variable "sub_project_dynamodb_sequence_generator" {
  type = string
}

variable "sub_project_psn_proxy_route_53" {
  type = string
}

variable "pipeline_name" {
  type = string
}
