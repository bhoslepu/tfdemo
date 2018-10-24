variable name {}
variable vpc_id {}
variable cidr {}
variable env {}
variable id {}

#security group for mysql
resource "aws_security_group" "petclinic-buildserver" {
  name        = "petclinic-buildserver"
  description = "Allows incoming traffic for Jenkins and SSH "

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = ["${aws_security_group.petclinic-bastion.id}"]
    self            = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.env}-${var.id}-petclinic-buildserver"
  }

  lifecycle {
    ignore_changes = ["ingress", "egress"]
  }
}

#output_variable_buildserver
output "petclinic-buildserver-sg" {
  value = "${aws_security_group.petclinic-buildserver.id}"
}

#security group for Bastion
resource "aws_security_group" "petclinic-bastion" {
  name        = "petclinic-bastion"
  description = "Allows incoming traffic for Bastion"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.env}-${var.id}-petclinic-bastion"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = ["ingress", "egress"]
  }
}

#output_variable_bastion
output "petclinic-bastion-sg" {
  value = "${aws_security_group.petclinic-bastion.id}"
}

#security group for Application Server Group
resource "aws_security_group" "petclinic-app" {
  name        = "petclinic-app"
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
    security_groups = ["${aws_security_group.petclinic-bastion.id}"]
    self            = true
  }

  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.env}-${var.id}-petclinic-app"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    ignore_changes = ["ingress", "egress"]
  }
}

#output_variable_AppliationGroup
output "petclinic-app-sg" {
  value = "${aws_security_group.petclinic-app.id}"
}
