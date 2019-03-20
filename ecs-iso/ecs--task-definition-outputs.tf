
# TASK DEFINITION
output "task_definition_arn" {
  value = "${module.app_task_definition.task_definition_arn}"
}

output "task_definition_family" {
  value = "${module.app_task_definition.task_definition_family}"
}

output "task_definition_revision" {
  value = "${module.app_task_definition.task_definition_revision}"
}
