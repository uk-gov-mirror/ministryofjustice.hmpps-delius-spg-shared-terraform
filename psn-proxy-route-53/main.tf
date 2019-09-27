terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = ">= 2.1.0"
}

locals {
  public_zone_id      = "${data.terraform_remote_state.vpc.strategic_public_zone_id}"
  public_zone_name    = "${data.terraform_remote_state.vpc.strategic_public_zone_name}"
  psn_facing_ips      = "${var.psn_facing_ips}"
  internet_facing_ips = "${var.internet_facing_ips}"
  is_production       = "${var.is_production}"
}

output "strategic_external_domain" {
  value = "${data.terraform_remote_state.vpc.strategic_public_zone_name}"
}

output "strategic_public_zone_id" {
  value = "${data.terraform_remote_state.vpc.strategic_public_zone_id}"
}

resource "aws_route53_record" "psn_facing" {
  count   = "${(local.is_production == true) ? 1 : 0}"
  zone_id = "${local.public_zone_id}"
  name    = "spgw-ext-psn"
  type    = "A"
  ttl     = "30"
  records = "${local.psn_facing_ips}"
}

resource "aws_route53_record" "internet_facing" {
  count   = "${(local.is_production == true) ? 1 : 0}"
  zone_id = "${local.public_zone_id}"
  name    = "spgw-int-psn"
  type    = "A"
  ttl     = "30"

  records = "${local.internet_facing_ips}"
}
