variable "region" {
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "allowed_cidr_block" {
  type = list(string)
}

variable "weblogic_domain_ports" {
  type        = map(string)
  description = "Map of the ports that the weblogic domains use"
}

variable "spg_partnergateway_domain_ports" {
  type        = map(string)
  description = "Map of the ports that the spg partner gateway servicemix domains use"
}

variable "tags" {
  type = map(string)
}

# SPG vars
variable "spg_app_name" {
  description = "label for spg"
}

variable "environment_name" {
  type = string
}

variable "PO_SPG_FIREWALL_INGRESS_PORT" {
}

variable "PO_SPG_FIREWALL_INGRESS_RULES" {
  description = "map of PO firewall configs"
  type        = map(string)
}

variable "internet_facing_ips" {
  type    = list(string)
  default = []
}

variable "is_production" {
}

variable "eng_remote_state_bucket_name" {
}

variable "eng_role_arn" {
}

