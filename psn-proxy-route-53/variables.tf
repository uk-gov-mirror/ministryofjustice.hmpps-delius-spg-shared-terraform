# Common variables
## remote states
variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "region" {
  description = "The AWS region."
}

variable "public_dns_child_zone" {
}

variable "public_dns_parent_zone" {
}

variable "route53_strategic_hosted_zone_id" {
  default = "zonenotimplementedyet"
}

variable "is_production" {
}

variable "psn_facing_ips" {
  type    = list(string)
  default = []
}

variable "internet_facing_ips" {
  type    = list(string)
  default = []
}

