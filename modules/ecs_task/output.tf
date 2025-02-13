output "task_definition_arn" {
  value = aws_ecs_task_definition.environment.arn
}

output "task_definition_family" {
  value = aws_ecs_task_definition.environment.family
}

output "task_definition_revision" {
  value = aws_ecs_task_definition.environment.revision
}

output "hmpps_asset_name_prefix" {
  value = var.hmpps_asset_name_prefix
}
