
output "ecs_spg_public_subnet_ids" {
  value = "${local.public_subnet_ids}"
}

output "ecs_spg_private_subnet_ids" {
  value = "${local.private_subnet_ids}"
}
