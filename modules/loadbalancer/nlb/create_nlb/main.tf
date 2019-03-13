resource "aws_lb" "environment" {
  name               = "${var.lb_name}-lb"
  internal           = "${var.internal}"
  load_balancer_type = "network"

  // security groups not possible with nlb
//  security_groups    = ["${var.security_groups}"]
  subnets            = ["${var.subnet_ids}"]

  enable_deletion_protection = "${var.enable_deletion_protection}"

  access_logs {
    bucket  = "${var.s3_bucket_name}"
    prefix  = "${var.lb_name}-lb"
    enabled = "${var.logs_enabled}"
  }

  tags = "${merge(var.tags, map("Name", "${var.lb_name}-lb"))}"

  lifecycle {
    create_before_destroy = true
  }


  subnet_mapping {
    subnet_id     = "${aws_subnet.example1.id}"
    allocation_id = "${aws_eip.example1.id}"
  }

  subnet_mapping {
    subnet_id     = "${aws_subnet.example2.id}"
    allocation_id = "${aws_eip.example2.id}"
  }

}
