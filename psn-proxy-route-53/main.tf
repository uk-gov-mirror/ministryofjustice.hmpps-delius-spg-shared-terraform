###strategic - only create if the primary zone id is different to the strategic one


locals {
  public_zone_id = "${data.terraform_remote_state.vpc.strategic_public_zone_id}"
  public_zone_name = "${data.terraform_remote_state.vpc.strategic_public_zone_name}"
  psn_facing_ips =    "${vars.psn_facing_ips}"
  internet_facing_ips =    "${vars.internet_facing_ips}"
}

output "strategic_external_domain" {
  value = "${data.terraform_remote_state.vpc.strategic_public_zone_name}"
}

output "strategic_public_zone_id" {
  value = "${data.terraform_remote_state.vpc.strategic_public_zone_id}"
}


resource "aws_route53_record" "psn_facing" {
  count = "${(is_production == true) ? 1 : 0}"
  zone_id = "${local.public_zone_id}"
  name    = "spgw-psn-ext"
  type    = "A"

  records =
    "${local.psn_facing_ips}"
}

resource "aws_route53_record" "internet_facing" {
  count = "${(is_production == true) ? 1 : 0}"
  zone_id = "${local.public_zone_id}"
  name    = "spgw-psn-ext"
  type    = "A"

  records =
  "${local.internet_facing_ips}"
}