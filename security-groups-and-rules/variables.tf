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

# SPG vars
variable "spg_app_name" {
  description = "label for spg"
}

variable "environment_name" {
  type = "string"
}


variable PO_SPG_FIREWALL_INGRESS_PORT {}
variable PO_SPG_FIREWALL_INGRESS_RULES {
  description ="map of PO firewall configs"
  type="map"
}

variable internet_facing_ips {
  type = "list"
  default = []
}