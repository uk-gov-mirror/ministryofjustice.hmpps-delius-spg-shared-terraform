# Performance testing auto-scaling group

resource "aws_launch_configuration" "launch_cfg" {
  name_prefix          = "${local.common_name}-launch-cfg-"
  image_id             = data.aws_ami.amazon_ami.id
  instance_type        = var.instance_type
  //TODO: no idea why iam_policy_ext_app_instance_profile_name is missing
  iam_instance_profile = data.terraform_remote_state.iam.outputs.iam_policy_iso_ext_app_instance_profile_name
  key_name             = data.terraform_remote_state.vpc.outputs.ssh_deployer_key
  security_groups = [
    data.terraform_remote_state.vpc_security_groups.outputs.sg_ssh_bastion_in_id,
    aws_security_group.spg_perf.id,
  ]
  associate_public_ip_address = "false"
  user_data                   = data.template_file.user_data.rendered
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
  count = length(keys(var.tags))
  inputs = {
    key                 = element(keys(var.tags), count.index)
    value               = element(values(var.tags), count.index)
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "perf_asg" {
  name = local.common_name
  # TF-UPGRADE-TODO: In Terraform v0.10 and earlier, it was sometimes necessary to
  # force an interpolation expression to be interpreted as a list by wrapping it
  # in an extra set of list brackets. That form was supported for compatibility in
  # v0.11, but is no longer supported in Terraform v0.12.
  #
  # If the expression in the following list itself returns a list, remove the
  # brackets to avoid interpretation as a list of lists. If the expression
  # returns a single list item then leave it as-is and remove this TODO comment.
  vpc_zone_identifier = data.terraform_remote_state.common.outputs.private_subnet_ids
  min_size = local.asg_min
  max_size = local.asg_max
  desired_capacity = local.asg_desired
  launch_configuration = aws_launch_configuration.launch_cfg.id

  lifecycle {
    create_before_destroy = true
  }

  tags = concat(
  data.null_data_source.tags.*.outputs,
  [
    {
      key = "Name"
      value = "${data.terraform_remote_state.common.outputs.common_name}-${local.app_name}-asg"
      propagate_at_launch = true
    },
  ]
  )
}

