# region
variable "region" {}
variable SPG_ENVIRONMENT_CODE {}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "hash_key" {
  default = "id"
}

variable "read_capacity" {
  default = "10"
}

variable "write_capacity" {
  default = "5"
}

variable "initial_sequence_value" {
  default = "0"
}

variable "tags" {
  type = "map"
}
