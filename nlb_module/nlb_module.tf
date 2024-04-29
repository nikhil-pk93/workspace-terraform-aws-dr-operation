module "shared_vars" {
  source = "../shared_vars"
}

variable "publicsg1" {}
variable "publicsg2" {}
variable "tg_arn_nlb_80"{}
variable "tg_arn_nlb_443"{}

resource "aws_lb" "alm-dr-nlb" {
  name               = "alm-dr-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${var.publicsg1}","${var.publicsg2}"]

  enable_deletion_protection = false

  tags = {
    Environment = "alm-dr-nlb"
  }
}

##Add listeners

resource "aws_lb_listener" "tg_arn_nlb_80" {
  load_balancer_arn = "${aws_lb.alm-dr-nlb.arn}"
  port              = "80"
  protocol          = "TCP"
  

  default_action {
    type             = "forward"
    target_group_arn = "${var.tg_arn_nlb_80}"
  }
}

resource "aws_lb_listener" "tg_arn_nlb_443" {
  load_balancer_arn = "${aws_lb.alm-dr-nlb.arn}"
  port              = "443"
  protocol          = "TCP"
  

  default_action {
    type             = "forward"
    target_group_arn = "${var.tg_arn_nlb_443}"
  }
}