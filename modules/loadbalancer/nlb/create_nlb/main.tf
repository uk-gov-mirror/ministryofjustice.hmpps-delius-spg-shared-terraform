resource "aws_lb" "environment" {
  name = "${var.lb_name}-nlb"
  internal = "false"
  load_balancer_type = "network"

  enable_deletion_protection = "${var.enable_deletion_protection}"

  access_logs {
    bucket = "${var.s3_bucket_name}"
    prefix = "${var.lb_name}-lb"
    enabled = "${var.logs_enabled}"
  }

  tags = "${merge(var.tags, map("Name", "${var.lb_name}-lb"))}"

  lifecycle {
    create_before_destroy = true
  }

  subnet_mapping {
    subnet_id = "${var.public_subnet_ids[0]}"
    allocation_id = "${var.az_lb_eip_allocation_ids[0]}"
  }

  subnet_mapping {
    subnet_id = "${var.public_subnet_ids[1]}"
    allocation_id = "${var.az_lb_eip_allocation_ids[1]}"
  }

  subnet_mapping {
    subnet_id = "${var.public_subnet_ids[2]}"
    allocation_id = "${var.az_lb_eip_allocation_ids[2]}"
  }

}
