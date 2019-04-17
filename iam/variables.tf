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

variable "environment_identifier" {}

variable "spg_app_name" {}




variable "backups-bucket-name" {
  default="backups-s3-bucket"
}

variable "depends_on" {
  default = []
  type    = "list"
}
