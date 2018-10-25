variable "key_name" {}
variable "ami" {}
variable "subnet-id" {}
variable "env" {}
variable "id" {}
variable "instance-type" {
  default = "t2.micro"
}
variable "region" {}
variable "az" {}

variable "security-group" {
  type = "list"
}

#EC2 instance creation with setting hostname using user-data
resource "aws_instance" "ec2-instance" {
  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet-id}"
  vpc_security_group_ids = ["${var.security-group}"]
  ami                    = "${var.ami}"
  instance_type          = "${var.instance-type}"
  availability_zone      = "${var.az}"

  tags {
    Name = "${var.env}-${var.id}-${var.az}-bastion"
  }

  lifecycle {
    create_before_destroy = true
  }

  root_block_device {
    volume_type           = "gp2"
    delete_on_termination = true
  }
}
#Instance private IP
output "private_ips" {
  value = "${aws_instance.ec2-instance.private_ip}"
}

#Instance name
output "tag_name" {
  value = "${aws_instance.ec2-instance.tags.Name}"
}

#Instance ID
output "instance_id" {
  value = "${aws_instance.ec2-instance.id}"
}
