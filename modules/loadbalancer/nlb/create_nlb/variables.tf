variable "lb_name" {}

variable "internal" {
  default = "true"
}

variable "subnet_ids" {
  type = "list"
}

variable "enable_deletion_protection" {
  default = "false"
}

variable "s3_bucket_name" {}

variable "logs_enabled" {
  default = "true"
}

variable "load_balancer_type" {
  default = "network"
}

variable "tags" {
  type = "map"
}
