terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = ">= 2.1.0"
}

variable "region" {
  type        = "string"
  default     = "eu-west-2"
  description = "The default deployment region (London)"
}

locals {

  pattern = "messageNotificationStatusCode=601"
}

output "pattern" {
  value =  "${urlencode(local.pattern)}"
}
