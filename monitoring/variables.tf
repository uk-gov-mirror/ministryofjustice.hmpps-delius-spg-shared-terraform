# region
variable "region" {}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "alarms_enabled" {
  type    = "string"
  default = "false"
}

variable "build_tag" {
  description = "Semantic version number"
  default     = "0.0"
}

variable "tags" {
  type        = "map"
  description = "Default tag set"
}

variable "lambda_runtime" {
  description = "Lambda runtime"
  type        = "string"
  default     = "nodejs12.x"
}