# SG for ElasticSearch VPC Endpoint
# Ingress rules will be added ........ TODO
resource "aws_security_group" "elk-audit_sg" {
  name        = "${local.name_prefix}-elk-audit-main-sg"
  description = "NDST ELK Audit Stack Security Group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-elk-audit-main-ecs"
    },
  )
}

resource "aws_security_group_rule" "elk-audit_ingress_bastion" {
  security_group_id = aws_security_group.elk-audit_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  cidr_blocks = values(data.terraform_remote_state.vpc.outputs.bastion_vpc_public_cidr)
  description = "ES and Kibana ingress via bastion"
}

resource "aws_security_group_rule" "elk-audit_ingress_servers" {
  security_group_id = aws_security_group.elk-audit_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  cidr_blocks = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
  description = "ES and Kibana ingress via bastion"
}

resource "aws_security_group_rule" "elk-audit_jenkins_servers" {
  security_group_id = aws_security_group.elk-audit_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  cidr_blocks = [data.terraform_remote_state.vpc.outputs.eng_vpc_cidr]
  description = "ES and Kibana ingress via jenkins"
}

resource "aws_elasticsearch_domain" "elk-audit_domain" {
  domain_name           = local.domain_name
  elasticsearch_version = var.elk-audit_conf["es_version"]

  vpc_options {
    # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
    # force an interpolation expression to be interpreted as a list by wrapping it
    # in an extra set of list brackets. That form was supported for compatibility in
    # v0.11, but is no longer supported in Terraform v0.12.
    #
    # If the expression in the following list itself returns a list, remove the
    # brackets to avoid interpretation as a list of lists. If the expression
    # returns a single list item then leave it as-is and remove this TODO comment.
    subnet_ids = local.es_subnets


    security_group_ids = [aws_security_group.elk-audit_sg.id]
  }

  cluster_config {
    instance_count           = var.is_elk_prod ? 3 : 1
    instance_type            = var.is_elk_prod ? "m5.large.elasticsearch" : "t2.small.elasticsearch"
    dedicated_master_enabled = var.elk-audit_conf["es_dedicated_master_enabled"]
    dedicated_master_count   = var.elk-audit_conf["es_dedicated_master_count"]
    dedicated_master_type    = var.elk-audit_conf["es_dedicated_master_type"]
    zone_awareness_enabled   = var.is_elk_prod

    zone_awareness_config {
      # Number of AZs must be either 2 or 3 and equal to subnet count when multi az / zone awareness is enabled
      availability_zone_count = 3
    }
  }

  ebs_options {
    ebs_enabled = var.elk-audit_conf["es_ebs_enabled"]
    volume_type = var.elk-audit_conf["es_ebs_type"]
    volume_size = var.elk-audit_conf["es_ebs_size"]
  }

  encrypt_at_rest {
    enabled = var.elk-audit_conf["es_ebs_encrypted"]
  }

  node_to_node_encryption {
    enabled = var.elk-audit_conf["es_internode_encryption"]
  }

  cognito_options {
    enabled          = var.elk-audit_conf["auth_enabled"]
    user_pool_id     = aws_cognito_user_pool.elk-audit_user_pool.id
    identity_pool_id = aws_cognito_identity_pool.elk-audit_identity_pool.id
    role_arn         = aws_iam_role.elk-audit_kibana_role.arn
  }

  advanced_options = var.elk-audit_advanced_cluster_conf

  access_policies = data.template_file.elk-audit_accesspolicy_template.rendered

  snapshot_options {
    automated_snapshot_start_hour = var.elk-audit_conf["es_snapshot_hour"]
  }

  log_publishing_options {
    enabled                  = var.elk-audit_conf["es_logging_enabled"]
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.elk-audit_log_group.arn
    log_type                 = var.elk-audit_conf["es_log_type"]
  }

  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-elk-audit-main-ecs"
    },
    {
      "Domain" = var.elk-audit_conf["es_domain"]
    },
  )

  # Explicitly declare dependencies - TF doesn't graph these well enough
  depends_on = [
    aws_iam_role.elk-audit_kibana_role,
    aws_cloudwatch_log_resource_policy.elk-audit_log_access,
  ]
}

# Value must be updated when administering the webops kibana user in cognito
# This is just a placeholder to store the secure password
resource "aws_ssm_parameter" "kibana_webops_password" {
  name      = "${local.name_prefix}-kibana-main-ssm"
  type      = "SecureString"
  value     = "null"
  overwrite = "true"
}

