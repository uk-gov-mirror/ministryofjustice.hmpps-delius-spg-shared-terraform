resource "aws_route53_record" "dns_spg_aes_int_entry" {
  # Use the ID of the Hosted Zone we retrieved earlier
  zone_id = data.terraform_remote_state.vpc.outputs.private_zone_id
  name    = "amazones-audit"
  type    = "CNAME"
  ttl     = "1800"
  count   = 1
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  records = [data.terraform_remote_state.elk-service.outputs.ndst_elk-audit_config.endpoint]
}

resource "aws_route53_record" "dns_spg_aes_ext_entry" {
  # The .probation DNS name for Jenkins to use
  zone_id = data.terraform_remote_state.common.outputs.strategic_public_zone_id
  name    = "amazones-audit"
  type    = "CNAME"
  ttl     = "1800"
  count   = 1
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  records = [data.terraform_remote_state.elk-service.outputs.ndst_elk-audit_config.endpoint]
}

