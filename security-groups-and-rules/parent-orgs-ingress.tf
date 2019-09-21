
# TODO move this group to network level, so other appliances can use rules
resource "aws_security_group" "parent_orgs_spg_ingress" {
  name        = "${local.common_name}-parent-orgs-spg-ingress"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"
  description = "Rules to allow POs and proxies into SPG enabled appliances"
  tags        = "${merge(var.tags, map("Name", "${var.environment_name}-parent-orgs-spg-ingress", "Type", "WEB"))}"

  lifecycle {
    create_before_destroy = true
  }
}





###################
# INGRESS
###################



data "template_file" "po_configuration" {
  template = "${file("templates/key_value_pair.tpl.json")}"
  count = "${length(var.PO_SPG_FIREWALL_INGRESS_RULES)}"


  vars {
    name = "${element(keys(var.PO_SPG_FIREWALL_INGRESS_RULES),count.index)}"
    value = "${element(values(var.PO_SPG_FIREWALL_INGRESS_RULES),count.index)}"
  }
}


resource "aws_security_group_rule" "parent_orgs_spg_ingress" {
  count = "${length(var.PO_SPG_FIREWALL_INGRESS_RULES)}"
  //key  = "${element(keys(var.PO_SPG_FIREWALL_INGRESS_RULES),count.index)}"
  //value  = "${element(values(var.PO_SPG_FIREWALL_INGRESS_RULES),count.index)}"


  security_group_id        = "${aws_security_group.parent_orgs_spg_ingress.id}"
  description              = "${element(keys(var.PO_SPG_FIREWALL_INGRESS_RULES),count.index)}"
  type                     = "ingress"
  cidr_blocks              = ["${element(values(var.PO_SPG_FIREWALL_INGRESS_RULES),count.index)}"]
  from_port                = "${var.PO_SPG_FIREWALL_INGRESS_PORT}"
  to_port                  = "${var.PO_SPG_FIREWALL_INGRESS_PORT}"
  protocol                 = "tcp"
}






