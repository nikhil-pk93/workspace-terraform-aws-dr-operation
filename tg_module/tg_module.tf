variable "vpcdr" {}
variable "alb_arn" {}

# variable "alb_arn" {}
module "shared_vars" {
  source = "../shared_vars"
}

resource "aws_lb_target_group" "alb-dr-tg" {
  name        = "${module.shared_vars.tgalb}"
  port        = 80
  protocol    = "HTTP"
  vpc_id     = "${var.vpcdr}"
  }

output "tg_arn" {
  value = "${aws_lb_target_group.alb-dr-tg.arn}"
}



resource "aws_lb_target_group_attachment" "almdrtargets" {
  target_group_arn = aws_lb_target_group.alb-dr-tg.arn
  target_id        = "${var.alb_arn}"
  # port             = 80
}
##Tg for NLB

# resource "aws_lb_target_group" "alb-dr-tg-nlb-80" {
#   name        = "alb-dr-tg-nlb-80"
#   target_type = "alb"
#   port        = 80
#   protocol    = "TCP"
#   vpc_id     = "${var.vpcdr}"
#   }

# output "tg_arn_nlb_80" {
#   value = "${aws_lb_target_group.alb-dr-tg-nlb-80.arn}"
# }

# resource "aws_lb_target_group" "alb-dr-tg-nlb-443" {
#   name        = "alb-dr-tg-nlb-443"
#   target_type = "alb"
#   port        = 443
#   protocol    = "TCP"
#   vpc_id     = "${var.vpcdr}"
#   }

# output "tg_arn_nlb_443" {
#   value = "${aws_lb_target_group.alb-dr-tg-nlb-443.arn}"
# }