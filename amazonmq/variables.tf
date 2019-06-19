variable "region" {
  type        = "string"
  default     = "eu-west-2"
  description = "The default deployment region (London)"
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}
