variable "region" {}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "allowed_cidr_block" {
  type = "list"
}

variable "weblogic_domain_ports" {
  type        = "map"
  description = "Map of the ports that the weblogic domains use"
}

variable "spg_partnergateway_domain_ports" {
  type        = "map"
  description = "Map of the ports that the spg partner gateway servicemix domains use"
}

variable "tags" {
  type = "map"
}
