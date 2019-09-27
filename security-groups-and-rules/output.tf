# SECURITY GROUPS


output "spg_common_outbound_sg_id" {
  value = "${aws_security_group.spg_common_outbound.id}"
}

output "external_9001_from_vpc_sg_id" {
  value = "${aws_security_group.external_9001_from_vpc.id}"
}


output "iso_external_instance_sg_id" {
  value = "${aws_security_group.external_iso_instance.id}"
}

output "parent_orgs_spg_ingress_sg_id" {
  value = "${aws_security_group.parent_orgs_spg_ingress.id}"
}




output "mpx_internal_loadbalancer_sg_id" {
  value = "${aws_security_group.internal_mpx_loadbalancer.id}"
}

output "mpx_internal_instance_sg_id" {
  value = "${aws_security_group.internal_mpx_instance.id}"
}



output "crc_internal_loadbalancer_sg_id" {
  value = "${aws_security_group.internal_crc_loadbalancer.id}"
}

output "crc_internal_instance_sg_id" {
  value = "${aws_security_group.internal_crc_instance.id}"
}
