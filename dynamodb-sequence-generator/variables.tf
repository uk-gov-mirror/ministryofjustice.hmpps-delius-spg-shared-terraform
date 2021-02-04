# region
variable "region" {
}

variable "SPG_ENVIRONMENT_CODE" {
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "tags" {
  type = map(string)
}

