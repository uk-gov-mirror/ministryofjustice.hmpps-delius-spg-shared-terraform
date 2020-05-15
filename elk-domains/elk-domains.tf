resource "aws_route53_record" "dns_spg_aes_int_entry" {

  # Use the ID of the Hosted Zone we retrieved earlier
  zone_id = "${data.terraform_remote_state.vpc.private_zone_id}"
  name = "amazones-audit"
  type = "CNAME"
  ttl = "1800"
  count = 1
  records = ["${data.terraform_remote_state.elk-service.ndst_elk-audit_config.endpoint}"]
}

resource "aws_route53_record" "dns_spg_aes_ext_entry" {

  # The .probation DNS name for Jenkins to use
  zone_id = "${data.terraform_remote_state.common.strategic_public_zone_id}"
  name = "amazones-audit"
  type = "CNAME"
  ttl = "1800"
  count = 1
  records = ["${data.terraform_remote_state.elk-service.ndst_elk-audit_config.endpoint}"]
}