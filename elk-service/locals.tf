locals {
  # Handle mixed environments project name
  name_prefix = data.terraform_remote_state.common.outputs.hmpps_asset_name_prefix

  name_prefix_length = length(local.name_prefix)
  es_domain_length   = length(var.elk-audit_conf["es_domain"])
  domain_name_length = local.name_prefix_length + local.es_domain_length > 27 ? 28 : local.name_prefix_length + local.es_domain_length + 1

  domain_name = substr(
    format("%s-%s", local.name_prefix, var.elk-audit_conf["es_domain"]),
    0,
    local.domain_name_length,
  )

  # Handle ES config for single instance or multiple instance deployments
  es_single_instance_subnet_id = [
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az1,
  ]

  private_subnet_ids = [
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az1,
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az2,
    data.terraform_remote_state.vpc.outputs.vpc_private-subnet-az3,
  ]

  # ES Subnets needs to match number of of instances upto a max value of 3 (max no of AZs in a region)
  es_subnet_count = var.is_elk_prod ? 3 : 1

  # List of ES subnets
  es_subnets = null_resource.subnet_list.*.triggers.subnet

}

# Build list of subnets from private subnet ids equal to number of ES subnets required
resource "null_resource" "subnet_list" {
  count = var.is_elk_prod ? 3 : 1

  triggers = {
    subnet = local.private_subnet_ids[count.index]
  }
}

