variable "vpcdr" {}
variable "tg_arn" {}
variable "publicsg1" {}
variable "publicsg2" {}



module "shared_vars" {
  source = "../shared_vars"
}

resource "aws_security_group" "alb-security" {
  name ="alb_dr_drsultan_sg"
  description = "Allow incoming HTTP Connections"
  vpc_id = "${var.vpcdr}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}



resource "aws_lb" "test" {
  name               = "project-dr-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-security.id]
  subnets            = ["${var.publicsg1}","${var.publicsg2}"]

  enable_deletion_protection = false



  tags = {
    Environment = "production-DR"
  }
}

output "alb_arn" {
  value = "${aws_lb.test.arn}"
}



resource "aws_lb_listener" "http_listner_80" {
  load_balancer_arn = "${aws_lb.test.arn }"
  port = "80"
  protocol = "HTTP"
  default_action {
     type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "http_listner_443" {
  load_balancer_arn = "${aws_lb.test.arn }"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:me-south-1:758650487731:certificate/c9aba833-a1b1-4fbc-910b-630afc7f8265"

  default_action {
    type             = "forward"
    target_group_arn = "${var.tg_arn}"
  }
}
