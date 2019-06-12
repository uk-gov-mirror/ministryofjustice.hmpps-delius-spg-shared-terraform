############################################
# CREATE ECS TASK DEFINTIONS
############################################

data "aws_ecs_task_definition" "app_task_definition" {
  task_definition = "${module.app_task_definition.task_definition_family}"
  depends_on      = ["module.app_task_definition"]
}

data "template_file" "app_task_definition" {
  template = "${file("task_definitions/template.json")}"

  vars {
    container_name        = "${local.app_name}-${local.app_submodule}"
    cpu_units             = "${local.backend_ecs_cpu_units}"
    memory                = "${local.backend_ecs_memory}"

    image_url             = "${local.image_url}"
    version               = "${local.image_version}"

    log_group_name        = "${module.create_loggroup.loggroup_name}"
    log_group_region      = "${var.region}"

    data_volume_host_path = "${local.data_volume_host_path}"
    data_volume_name      = "${local.data_volume_name}"


    kibana_host           = "${local.kibana_host}"
    s3_bucket_config = "${local.s3_bucket_config}"
    spg_build_inv_dir = "${local.spg_build_inv_dir}"


  }
}

module "app_task_definition" {
  source   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//ecs//ecs-taskdefinitions//appwith_single_volume"
  app_name = "${local.common_name}"

  container_name        = "${local.common_name}"
  container_definitions = "${data.template_file.app_task_definition.rendered}"

  data_volume_host_path = "${local.data_volume_host_path}"
  data_volume_name      = "${local.data_volume_name}"

}
