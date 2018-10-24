variable "key_name" {}
variable "ami" {}
variable "subnet-id" {}
variable "env" {}
variable "id" {}
variable "instance-count" {
  default = "1"
}
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
  count                  = "${var.instance-count}"
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

  user_data = <<EOT
#!/bin/bash -v
amazon-linux-extras install ansible2
yum update –y
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key          
yum install -y java
yum install -y jenkins
service jenkins start
EOT
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
