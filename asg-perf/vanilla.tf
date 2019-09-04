# Performance testing auto-scaling group

resource "aws_launch_configuration" "launch_cfg" {
  name_prefix                 = "${local.common_name}-launch-cfg-"
  image_id                    = "${data.aws_ami.amazon_ami.id}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${data.terraform_remote_state.iam.iam_policy_ext_app_instance_profile_name}"
  key_name                    = "${data.terraform_remote_state.vpc.ssh_deployer_key}"
  security_groups             = [
                                  "${data.terraform_remote_state.vpc_security_groups.sg_ssh_bastion_in_id}",
                                  "${aws_security_group.spg_perf.id}",
                                ]
  associate_public_ip_address = "false"
  user_data                   = "${data.template_file.user_data.rendered}"
  enable_monitoring           = "true"
  ebs_optimized               = "false"

  root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }

  lifecycle {
    create_before_destroy = true
  }
}

# This null_data_source is required to convert our Map of tags, to the required List of tags for ASGs
# see: https://github.com/hashicorp/terraform/issues/16980
data "null_data_source" "tags" {
  count  = "${length(keys(var.tags))}"
  inputs = {
    key                 = "${element(keys(var.tags), count.index)}"
    value               = "${element(values(var.tags), count.index)}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "perf_asg" {
  name                 = "${local.common_name}"
  vpc_zone_identifier  = ["${data.terraform_remote_state.common.private_subnet_ids}"]
  min_size             = "${local.asg_min}"
  max_size             = "${local.asg_max}"
  desired_capacity     = "${local.asg_desired}"
  launch_configuration = "${aws_launch_configuration.launch_cfg.id}"

  lifecycle {
    create_before_destroy = true
  }

  tags = [
    "${data.null_data_source.tags.*.outputs}",
    {
      key                 = "Name"
      value               = "${data.terraform_remote_state.common.common_name}-${local.app_name}-asg"
      propagate_at_launch = true
    }
  ]
}
