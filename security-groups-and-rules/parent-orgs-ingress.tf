# TODO move this group to network level, so other appliances can use rules
resource "aws_security_group" "parent_orgs_spg_ingress" {
  name        = "${local.common_name}-parent-orgs-spg-ingress"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  description = "Rules to allow POs and proxies into SPG enabled appliances"
  tags = merge(
    var.tags,
    {
      "Name" = "${var.environment_name}-parent-orgs-spg-ingress"
      "Type" = "WEB"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

###################
# INGRESS
###################

data "template_file" "po_configuration" {
  template = file("templates/key_value_pair.tpl.json")
  count    = length(var.PO_SPG_FIREWALL_INGRESS_RULES)

  vars = {
    name  = element(keys(var.PO_SPG_FIREWALL_INGRESS_RULES), count.index)
    value = element(values(var.PO_SPG_FIREWALL_INGRESS_RULES), count.index)
  }
}

resource "aws_security_group_rule" "parent_orgs_spg_ingress" {
  count = length(var.PO_SPG_FIREWALL_INGRESS_RULES)

  //key  = "${element(keys(var.PO_SPG_FIREWALL_INGRESS_RULES),count.index)}"
  //value  = "${element(values(var.PO_SPG_FIREWALL_INGRESS_RULES),count.index)}"

  security_group_id = aws_security_group.parent_orgs_spg_ingress.id
  description       = "TF_${element(keys(var.PO_SPG_FIREWALL_INGRESS_RULES), count.index)}"
  type              = "ingress"
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  cidr_blocks = [element(values(var.PO_SPG_FIREWALL_INGRESS_RULES), count.index)]
  from_port   = var.PO_SPG_FIREWALL_INGRESS_PORT
  to_port     = var.PO_SPG_FIREWALL_INGRESS_PORT
  protocol    = "tcp"
}

