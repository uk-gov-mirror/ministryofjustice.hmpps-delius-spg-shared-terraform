variable "region" {}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "eng_role_arn" {}

variable "eng-remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "tags" {
  type = "map"
}
