#-------------------------------------------------------------
### generic rule for allowing port 9001 from vpc public nat
#-------------------------------------------------------------

output "external_9001_from_vpc_public_ips_sg_id" {
  value = aws_security_group.external_9001_from_vpc_public_ips.id
}

# 9001 rule group
resource "aws_security_group" "external_9001_from_vpc_public_ips" {
  name        = "${local.common_name}-external-9001-from-vpc-public-ips"
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

###################
# INGRESS
###################

#---------------------------------------------------------------------------------------
### port 9001 (soap/rest mutual TLS) from VPC public address for calls from CRC stub
#---------------------------------------------------------------------------------------

resource "aws_security_group_rule" "external_from_vpc_public_ips_9001_nataz1" {
  security_group_id = aws_security_group.external_9001_from_vpc_public_ips.id
  description       = "from vpcPublicIP AZ1 from crc stub"
  type              = "ingress"
  cidr_blocks       = ["${local.natgateway_common-nat-public-ip-az1}/32"] #from crc via public ip
  from_port         = 9001
  to_port           = 9001
  protocol          = "tcp"
}

resource "aws_security_group_rule" "external_from_vpc_public_ips_9001_nataz2" {
  security_group_id = aws_security_group.external_9001_from_vpc_public_ips.id
  description       = "from vpcPublicIP AZ2 from crc stub"
  type              = "ingress"
  cidr_blocks       = ["${local.natgateway_common-nat-public-ip-az2}/32"] #from crc via public ip
  from_port         = 9001
  to_port           = 9001
  protocol          = "tcp"
}

resource "aws_security_group_rule" "external_from_vpc_public_ips_9001_nataz3" {
  security_group_id = aws_security_group.external_9001_from_vpc_public_ips.id
  description       = "from vpcPublicIP AZ3 from crc stub"
  type              = "ingress"
  cidr_blocks       = ["${local.natgateway_common-nat-public-ip-az3}/32"] #from crc via public ip
  from_port         = 9001
  to_port           = 9001
  protocol          = "tcp"
}

