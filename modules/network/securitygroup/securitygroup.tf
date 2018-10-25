variable name {}
variable vpc_id {}
variable cidr {}
variable env {}
variable id {}

#security group for buildserver
resource "aws_security_group" "tfdemo-buildserver" {
  name        = "tfdemo-buildserver"
  description = "Allows incoming traffic for Jenkins and SSH "

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.tfdemo-bastion.id}"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.env}-${var.id}-tfdemo-buildserver"
  }

}

#output_variable_buildserver
output "tfdemo-buildserver-sg" {
  value = "${aws_security_group.tfdemo-buildserver.id}"
}

#security group for Bastion
resource "aws_security_group" "tfdemo-bastion" {
  name        = "tfdemo-bastion"
  description = "Allows incoming traffic for Bastion"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.env}-${var.id}-tfdemo-bastion"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#output_variable_bastion
output "tfdemo-bastion-sg" {
  value = "${aws_security_group.tfdemo-bastion.id}"
}

#security group for Application Server Group
resource "aws_security_group" "tfdemo-app" {
  name        = "tfdemo-app"
  description = "Allows incoming traffic for Application"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.tfdemo-bastion.id}"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.env}-${var.id}-tfdemo-app"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#output_variable_AppliationGroup
output "tfdemo-app-sg" {
  value = "${aws_security_group.tfdemo-app.id}"
}
