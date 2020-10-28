##IF you need to rename SGs, terraform will struggle to replace them due to
##instances / ENIs attached
#best way forwards is to put the group in this deprecated file, then remove when all environments have had
#the new SG relationships applied

# 9001 rule group deprecated 29/9/2019 replaced with external_9001_from_vpc_public_ips
resource "aws_security_group" "external_9001_from_vpc" {
  name        = "${local.common_name}-external-9001-from-vpc"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  description = "Port 9001 from vpc NAT"
  tags = merge(
    var.tags,
    {
      "Name" = "${var.environment_name}-${var.spg_app_name}-port-9001-from-vpc"
      "Type" = "WEB"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

