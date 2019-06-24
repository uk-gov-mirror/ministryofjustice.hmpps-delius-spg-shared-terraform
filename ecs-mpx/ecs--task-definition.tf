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
    container_name = "${local.app_name}-${local.app_submodule}"
    ecs_cpu_units = "${local.ecs_cpu_units}"
    ecs_memory = "${local.ecs_memory}"

    image_url = "${local.image_url}"
    version = "${local.image_version}"

    log_group_name = "${module.create_loggroup.loggroup_name}"
    log_group_region = "${var.region}"

    data_volume_host_path = "${local.data_volume_host_path}"
    data_volume_name = "${local.data_volume_name}"


    kibana_host = "${local.kibana_host}"
    s3_bucket_config = "${local.s3_bucket_config}"
    spg_build_inv_dir = "${local.spg_build_inv_dir}"


    SPG_ENVIRONMENT_CODE = "${local.SPG_ENVIRONMENT_CODE}"
    SPG_ENVIRONMENT_CN = "${local.SPG_ENVIRONMENT_CN}"
    SPG_JAVA_MAX_MEM = "${local.SPG_JAVA_MAX_MEM}"
    SPG_DELIUS_MQ_URL = "${local.SPG_DELIUS_MQ_URL}"
    SPG_GATEWAY_MQ_URL = "${local.SPG_GATEWAY_MQ_URL}"
    SPG_DOCUMENT_REST_SERVICE_ADMIN_URL = "${local.SPG_DOCUMENT_REST_SERVICE_ADMIN_URL}"
    SPG_DOCUMENT_REST_SERVICE_PUBLIC_URL = "${local.SPG_DOCUMENT_REST_SERVICE_PUBLIC_URL}"
    SPG_ISO_FQDN = "${local.SPG_ISO_FQDN}"
    SPG_MPX_FQDN = "${local.SPG_MPX_FQDN}"
    SPG_CRC_FQDN = "${local.SPG_CRC_FQDN}"


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
