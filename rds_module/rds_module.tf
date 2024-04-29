variable "vpcdr" {}
variable "node-sec" {}
variable "publicsg1" {}
variable "publicsg2" {}

module "shared_vars" {
    source = "../shared_vars"
}



resource "aws_security_group" "rdssg" {
    name = "rdssg"
    vpc_id =  "${var.vpcdr}"

    ingress {
        from_port = 1433
        to_port = 1433
        protocol = "tcp"
        security_groups = ["${var.node-sec}"]

    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
}

resource "aws_db_subnet_group" "default" {
  name       = "almarai-subnet-group"
  subnet_ids = ["${var.publicsg1}","${var.publicsg2}"]

  tags = {
    Name = "almarai-subnet-group"
  }
}

data "aws_db_snapshot" "latest_prod_snapshot" {
  db_instance_identifier = "project-production"
  most_recent            = true
}

resource "aws_db_instance" "rds-dr" {
  instance_class = "db.t3.medium"
  identifier = "project-dr"
  snapshot_identifier = "${data.aws_db_snapshot.latest_prod_snapshot.id}"
  backup_retention_period = 1
  multi_az = false
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rdssg.id]
  skip_final_snapshot = true
  storage_encrypted = true
  apply_immediately = true
  lifecycle {
    ignore_changes = [snapshot_identifier]
  }
}

