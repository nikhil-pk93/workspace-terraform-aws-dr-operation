variable "publicsg1" {}
variable "publicsg2" {}
variable "privatesg1" {}
variable "privatesg2" {}
variable "privatesg3" {}
variable "tg_arn" {}
variable "vpcdr" {}


module "shared_vars" {
  source = "../shared_vars"
}

resource "aws_security_group" "node-security" {
  name ="alb_dr_project_node"
  description = "Allow incomeing HTTP Connections"
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

output "node-sec" {
  value = aws_security_group.node-security.id
}


data "aws_ami" "latest_prod_snapshot" {
  most_recent  = true
   filter {
    name   = "name"
    values = ["project_prod_node_*"]
  }
}


resource "aws_launch_configuration" "as_conf" {
  name="project-dr-LC"
  image_id      = "${data.aws_ami.latest_prod_snapshot.id}"
  instance_type = "t3.medium"
  key_name = "dr-project-node"
  security_groups = [aws_security_group.node-security.id]
 

  lifecycle {
    create_before_destroy = true
  }
}



resource "aws_autoscaling_group" "bar" {
  name                      = "project-dr-test"
  max_size                  = 2
  min_size                  = 2
  target_group_arns         = ["${var.tg_arn}"]
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 2
  force_delete              = true
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = ["${var.privatesg1}","${var.privatesg2}","${var.privatesg3}"]

   tag {
    key                 = "Name"
    value               = "DR-Node"
    propagate_at_launch = true
  }

}

