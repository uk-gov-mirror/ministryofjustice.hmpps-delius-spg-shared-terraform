# SG for ElasticSearch VPC Endpoint
# Ingress rules will be added ........ TODO
resource "aws_security_group" "elk-audit_sg" {
  name        = "${local.name_prefix}-elk-audit-pri-sg"
  description = "NDST ELK Audit Stack Security Group"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  tags = "${
      merge(
          var.tags, 
          map("Name", "${local.name_prefix}-elk-audit-pri-ecs")
          )
        }"
}

resource "aws_security_group_rule" "elk-audit_ingress_bastion" {
  security_group_id = "${aws_security_group.elk-audit_sg.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["${values(data.terraform_remote_state.vpc.bastion_vpc_public_cidr)}"]
  description       = "ES and Kibana ingress via bastion"
}

resource "aws_security_group_rule" "elk-audit_ingress_servers" {
  security_group_id = "${aws_security_group.elk-audit_sg.id}"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["${data.terraform_remote_state.vpc.vpc_cidr_block}"]
  description       = "ES and Kibana ingress via bastion"
}

resource "aws_elasticsearch_domain" "elk-audit_domain" {
  domain_name           = "${var.elk-audit_conf["es_domain"]}"
  elasticsearch_version = "${var.elk-audit_conf["es_version"]}"

  vpc_options {
    subnet_ids = [
      "${local.es_subnets}",
    ]

    security_group_ids = ["${aws_security_group.elk-audit_sg.id}"]
  }

  cluster_config {
    instance_count           = "${var.elk-audit_conf["es_instance_count"]}"
    instance_type            = "${var.elk-audit_conf["es_instance_type"]}"
    dedicated_master_enabled = "${var.elk-audit_conf["es_dedicated_master_enabled"]}"
    dedicated_master_count   = "${var.elk-audit_conf["es_dedicated_master_count"]}"
    dedicated_master_type    = "${var.elk-audit_conf["es_dedicated_master_type"]}"
    zone_awareness_enabled   = "${var.elk-audit_conf["es_instance_count"] > 1 ? true : false}"

    zone_awareness_config {
      # Number of AZs must be either 2 or 3 and equal to subnet count when multi az / zone awareness is enabled
      availability_zone_count = "${var.elk-audit_conf["es_instance_count"] <= 2 ? 2 : 3}"
    }
  }

  ebs_options {
    ebs_enabled = "${var.elk-audit_conf["es_ebs_enabled"]}"
    volume_type = "${var.elk-audit_conf["es_ebs_type"]}"
    volume_size = "${var.elk-audit_conf["es_ebs_size"]}"
  }

  encrypt_at_rest {
    enabled = "${var.elk-audit_conf["es_ebs_encrypted"]}"
  }

  node_to_node_encryption {
    enabled = "${var.elk-audit_conf["es_internode_encryption"]}"
  }

  cognito_options {
    enabled          = "${var.elk-audit_conf["auth_enabled"]}"
    user_pool_id     = "${aws_cognito_user_pool.elk-audit_user_pool.id}"
    identity_pool_id = "${aws_cognito_identity_pool.elk-audit_identity_pool.id}"
    role_arn         = "${aws_iam_role.elk-audit_kibana_role.arn}"
  }

  advanced_options = "${var.elk-audit_advanced_cluster_conf}"

  access_policies = "${data.template_file.elk-audit_accesspolicy_template.rendered}"

  snapshot_options {
    automated_snapshot_start_hour = "${var.elk-audit_conf["es_snapshot_hour"]}"
  }

  log_publishing_options {
    enabled                  = "${var.elk-audit_conf["es_logging_enabled"]}"
    cloudwatch_log_group_arn = "${aws_cloudwatch_log_group.elk-audit_log_group.arn}"
    log_type                 = "${var.elk-audit_conf["es_log_type"]}"
  }

  tags = "${
      merge(
          var.tags, 
          map("Name", "${local.name_prefix}-elk-audit-pri-ecs"),
          map("Domain", "${var.elk-audit_conf["es_domain"]}")
          )
        }"

  # Explicitly declare dependencies - TF doesn't graph these well enough
  depends_on = [
    #"aws_iam_service_linked_role.elk-audit",
    "aws_iam_role.elk-audit_kibana_role",

    "aws_cloudwatch_log_resource_policy.elk-audit_log_access",
  ]

  # Workaround for issue always applying update when none needed on single instance domains
  # Given a cluster multi az setup can't be updated after initial creation, this should be safe
  lifecycle {
    ignore_changes = [
      "cluster_config.0.zone_awareness_config",
    ]
  }
}

# Value must be updated when administering the webops kibana user in cognito
# This is just a placeholder to store the secure password
resource "aws_ssm_parameter" "kibana_webops_password" {
  name  = "${local.name_prefix_conflict}-kibana-pri-ssm"
  type  = "SecureString"
  value = "null"
}

#
resource "aws_route53_record" "dns_spg_aes_int_entry" {

  # Use the ID of the Hosted Zone we retrieved earlier
  zone_id = "${data.terraform_remote_state.common.private_zone_id}"
  name = "amazones-audit"
  type = "CNAME"
  ttl = "1800"
  count = 1
  records = ["${aws_elasticsearch_domain.elk-audit_domain.endpoint}"]
  depends_on = ["aws_mq_broker.SPG"]
}
