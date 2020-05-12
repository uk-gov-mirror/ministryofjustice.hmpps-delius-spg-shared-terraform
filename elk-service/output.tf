output "ndst_elk-audit_config" {
  value = {
    securitygroup_id = "${aws_security_group.elk-audit_sg.id}"
    //domain_arn       = "${aws_elasticsearch_domain.elk-audit_domain.arn}"
    //domain_id        = "${aws_elasticsearch_domain.elk-audit_domain.domain_id}"
    domain_name      = "${aws_elasticsearch_domain.elk-audit_domain.domain_name}"
    //endpoint         = "${aws_elasticsearch_domain.elk-audit_domain.endpoint}"
    //kibana_endpoint  = "${aws_elasticsearch_domain.elk-audit_domain.kibana_endpoint}"
  }
}

output "name_prefix" {
  value = "${local.name_prefix}"
}

output "domain_name" {
  value = "${local.domain_name}"
}

output "non-prod cidr az1"{
  value = "${data.terraform_remote_state.engineering_nat.common-nat-public-ip-az1}"
}