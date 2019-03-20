variable "appname" {}

variable "target_port" {}
variable "target_protocol" {}
variable "vpc_id" {}

variable "deregistration_delay" {
  default = "300"
}

variable "target_type" {}

variable "tags" {
  type = "map"
}

