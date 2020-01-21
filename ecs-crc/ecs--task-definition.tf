############################################
# CREATE ECS TASK DEFINTIONS
############################################

data "aws_ecs_task_definition" "app_task_definition" {
  task_definition = "${module.app_task_definition.task_definition_family}"
  depends_on      = ["module.app_task_definition"]
}


data "template_file" "po_configuration" {
  template = "${file("task_definitions/key_value_pair.tpl.json")}"
  count = "${length(var.PO_SPG_CONFIGURATION)}"


  vars {
    name = "${element(keys(var.PO_SPG_CONFIGURATION),count.index)}"
    value = "${element(values(var.PO_SPG_CONFIGURATION),count.index)}"
  }
}

data "template_file" "app_task_definition" {
  template = "${file("task_definitions/template.json")}"

  vars {
    po_configuration = "${join(",", data.template_file.po_configuration.*.rendered)}"

    hmpps_asset_name_prefix = "${local.hmpps_asset_name_prefix}"

    container_name = "${local.app_name}-${local.app_submodule}"
    ecs_memory = "${local.ecs_memory}"

    image_url             = "${local.image_url}"
    version               = "${local.image_version}"

    log_group_name        = "${module.create_loggroup.loggroup_name}"
    log_group_region      = "${var.region}"

    data_volume_host_path = "${local.data_volume_host_path}"
    data_volume_name      = "${local.data_volume_name}"


    kibana_host           = "${local.kibana_host}"
    s3_bucket_config = "${local.s3_bucket_config}"

    SPG_HOST_TYPE = "${local.SPG_HOST_TYPE}"
    SPG_GENERIC_BUILD_INV_DIR = "${local.SPG_GENERIC_BUILD_INV_DIR}"
    SPG_JAVA_MAX_MEM = "${local.SPG_JAVA_MAX_MEM}"
    SPG_ENVIRONMENT_CODE = "${local.SPG_ENVIRONMENT_CODE}"
    SPG_ENVIRONMENT_CN = "${local.SPG_ENVIRONMENT_CN}"
    SPG_AWS_REGION = "${local.SPG_AWS_REGION}"
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
  source   = "..//modules//ecs_task"
  app_name = "${local.container_name}"
  hmpps_asset_name_prefix = "${local.hmpps_asset_name_prefix}"

  container_name        = "${local.container_name}"
  container_definitions = "${data.template_file.app_task_definition.rendered}"

  data_volume_host_path = "${local.data_volume_host_path}"
  data_volume_name      = "${local.data_volume_name}"

}
