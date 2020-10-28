variable "instance_type" {
  description = "Instance type for the weblogic server"
  type        = string
  default     = "t2.small"
}

variable "tags" {
  description = "Tags to match tagging standard"
  type        = map(string)
}

variable "region" {
  description = "The AWS region."
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_name" {
  description = "Name of the environment"
  type        = string
}

