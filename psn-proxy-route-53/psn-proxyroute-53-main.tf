//export TF_VAR_public_dns_parent_zone="service.justice.gov.uk"
//export TF_VAR_public_dns_child_zone="${TG_ENVIRONMENT_TYPE}.probation"

locals {
  public_zone_id      = var.route53_strategic_hosted_zone_id
  public_zone_name    = "${var.public_dns_child_zone}.${var.public_dns_parent_zone}"
  psn_facing_ips      = var.psn_facing_ips
  internet_facing_ips = var.internet_facing_ips
  is_production       = var.is_production
}

output "strategic_external_domain" {
  value = "${var.public_dns_child_zone}.${var.public_dns_parent_zone}"
}

output "strategic_public_zone_id" {
  value = var.route53_strategic_hosted_zone_id
}

resource "aws_route53_record" "psn_facing" {
  count   = local.is_production == true ? 1 : 0
  zone_id = local.public_zone_id
  name    = "spgw-ext-psn"
  type    = "A"
  ttl     = "30"
  records = local.psn_facing_ips
}

resource "aws_route53_record" "internet_facing" {
  count   = local.is_production == true ? 1 : 0
  zone_id = local.public_zone_id
  name    = "spgw-int-psn"
  type    = "A"
  ttl     = "30"

  records = local.internet_facing_ips
}

