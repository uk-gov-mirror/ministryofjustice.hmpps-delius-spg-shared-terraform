locals {
  # Handle mixed environments project name
  name_prefix = "${data.terraform_remote_state.common.hmpps_asset_name_prefix}"

  # Handle ES config for single instance or multiple instance deployments
  es_single_instance_subnet_id = [
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az1}",
  ]

  private_subnet_ids = [
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az1}",
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az2}",
    "${data.terraform_remote_state.vpc.vpc_private-subnet-az3}",
  ]

  # ES Subnets needs to match number of of instances upto a max value of 3 (max no of AZs in a region)
  es_subnet_count = "${var.elk-audit_conf["es_instance_count"] >= 3 ? 3 : var.elk-audit_conf["es_instance_count"]}"

  # List of ES subnets
  es_subnets = [
    "${null_resource.subnet_list.*.triggers.subnet}",
  ]
}

# Build list of subnets from private subnet ids equal to number of ES subnets required
resource "null_resource" "subnet_list" {
  count = "${local.es_subnet_count}"

  triggers {
    subnet = "${local.private_subnet_ids[count.index]}"
  }
}
