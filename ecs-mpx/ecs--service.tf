
############################################
# CREATE ECS CLUSTER FOR spg
############################################
# ##### ECS Cluster

module "ecs_cluster" {
  source       = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//ecs//ecs_cluster"
  cluster_name = "${local.common_name}"
}



############################################
# CREATE LOG GROUPS FOR CONTAINER LOGS
############################################

module "create_loggroup" {
  source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//cloudwatch//loggroup"
  log_group_path           = "${local.short_environment_name}"
  loggroupname             = "${local.app_name}-${local.app_submodule}"
  cloudwatch_log_retention = "${local.cloudwatch_log_retention}"
  tags                     = "${local.tags}"
}


############################################
# CREATE ECS SERVICES
############################################

#with predefined elb

module "app_service" {
  source                             = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//ecs/ecs_service//withloadbalancer//elb"
  servicename                        = "${local.common_name}"
  clustername                        = "${module.ecs_cluster.ecs_cluster_id}"
  ecs_service_role                   = "${local.ecs_service_role}"
  elb_name                           = "${module.create_app_elb.environment_elb_name}"
  containername                      = "${local.app_name}-${local.app_submodule}"
  containerport                      = "${local.backend_app_port}"
  task_definition_family             = "${module.app_task_definition.task_definition_family}"
  task_definition_revision           = "${module.app_task_definition.task_definition_revision}"
  current_task_definition_version    = "${data.aws_ecs_task_definition.app_task_definition.revision}"
  service_desired_count              = "${local.service_desired_count}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"
}




############################################
# CREATE USER DATA FOR EC2 RUNNING SERVICES
############################################

data "template_file" "user_data" {
  template = "${file("${local.user_data}")}"

  vars {
    ebs_device           = "${local.ebs_device_name}"
    app_name             = "${local.app_name}-${local.app_submodule}}"
    env_identifier       = "${local.environment_identifier}"
    short_env_identifier = "${local.short_environment_name}"
    cluster_name         = "${module.ecs_cluster.ecs_cluster_name}"
    log_group_name       = "${module.create_loggroup.loggroup_name}"
    container_name       = "${local.app_name}-${local.app_submodule}"
    bastion_inventory    = "${var.bastion_inventory}"


    data_volume_host_path      = "${local.data_volume_host_path}"
    data_volume_name           = "${local.data_volume_name}"
    esc_container_stop_timeout = "${var.esc_container_stop_timeout}"
  }
}

############################################
# CREATE LAUNCH CONFIG FOR EC2 RUNNING SERVICES
############################################

module "launch_cfg" {
  source                      = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//launch_configuration//blockdevice"
  launch_configuration_name   = "${local.common_name}"
  image_id                    = "${local.ami_id}"
  instance_type               = "${local.instance_type}"
  volume_size                 = "${local.volume_size}"
  instance_profile            = "${local.instance_profile}"
  key_name                    = "${local.ssh_deployer_key}"
  ebs_device_name             = "${local.ebs_device_name}"
  ebs_volume_type             = "${local.ebs_volume_type}"
  ebs_volume_size             = "${local.ebs_volume_size}"
  ebs_encrypted               = "${local.ebs_encrypted}"
  ##ebs_delete_on_termination   = "setthis if we dont get amazonmq any time soon"
  associate_public_ip_address = "${local.associate_public_ip_address}"
  security_groups             = ["${local.instance_security_groups}"]
  user_data                   = "${data.template_file.user_data.rendered}"

}

############################################
# CREATE AUTO SCALING GROUP
############################################

module "auto_scale" {
//  source               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//autoscaling//group//default"
  source               = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//autoscaling//group//asg_classic_lb"
  asg_name             = "${local.common_name}"
  subnet_ids           = ["${local.private_subnet_ids}"]
  asg_min              = "${local.asg_min}"
  asg_max              = "${local.asg_max}"
  asg_desired          = "${local.asg_desired}"
  launch_configuration = "${module.launch_cfg.launch_name}"
  tags                 = "${local.tags}"
  load_balancers       = ["${module.create_app_elb.environment_elb_name}"]
}
