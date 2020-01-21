output "ndst_elk-audit_config" {
  value = {
    securitygroup_id = "${aws_security_group.elk-audit_sg.id}"
    domain_arn       = "${aws_elasticsearch_domain.elk-audit_domain.arn}"
    domain_id        = "${aws_elasticsearch_domain.elk-audit_domain.domain_id}"
    domain_name      = "${aws_elasticsearch_domain.elk-audit_domain.domain_name}"
    endpoint         = "${aws_elasticsearch_domain.elk-audit_domain.endpoint}"
    kibana_endpoint  = "${aws_elasticsearch_domain.elk-audit_domain.kibana_endpoint}"
  }
}
