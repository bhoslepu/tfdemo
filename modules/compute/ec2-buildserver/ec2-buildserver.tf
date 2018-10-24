variable "key_name" {}
variable "ami" {}
variable "subnet-id" {}
variable "zone_id" {}
variable "az" {}
variable "env" {}
variable "id" {}
variable "instance-count" {}
variable "instance-type" {}
variable "region" {}
variable "role" {}

variable "security-group" {
  type = "list"
}

variable "region-domain" {}

resource "aws_instance" "ec2-instance" {
  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet-id}"
  vpc_security_group_ids = ["${var.security-group}"]
  ami                    = "${var.ami}"
  instance_type          = "${var.instance-type}"
  count                  = "${var.instance-count}"
  availability_zone      = "${var.az}"
  source_dest_check      = "false"

  tags {
    Name = "${format("${var.env}-${var.id}-${var.az}-${var.role}-%03d",count.index)}"
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
hostname "${format("${var.env}-${var.id}-${var.az}-${var.role}-%03d.${var.region-domain}",count.index)}"
PRIVATE_IP=`curl --silent http://169.254.169.254/latest/meta-data/local-ipv4`
echo "$PRIVATE_IP ${format("${var.env}-${var.id}-${var.az}-${var.role}-%03d.${var.region-domain}",count.index)}" >> /etc/hosts
sed -i.bak '/HOSTNAME=/d' /etc/sysconfig/network
sed -i.bak "1 a HOSTNAME=${format("${var.env}-${var.id}-${var.az}-${var.role}-%03d.${var.region-domain}",count.index)}" /etc/sysconfig/network 
EOT
}

#Instnace Route53 record
resource "aws_route53_record" "ec2-r53" {
  zone_id    = "${var.zone_id}"
  count      = "${var.instance-count}"
  name       = "${element(aws_instance.ec2-instance.*.tags.Name, count.index)}"
  type       = "A"
  ttl        = "600"
  records    = ["${element(aws_instance.ec2-instance.*.private_ip, count.index)}"]
  depends_on = ["aws_instance.ec2-instance"]
}

output "public_ips" {
  value = "${join(",", aws_instance.ec2-instance.*.public_ip)}"
}

output "private_ips" {
  value = "${join(",",aws_instance.ec2-instance.*.private_ip)}"
}

#instance output name

output "tag_name" {
  value = "${join(",",aws_instance.ec2-instance.*.tags.Name)}"
}

output "instance_id" {
  value = "${join(",",aws_instance.ec2-instance.*.id)}"
}

output "network_interface_id" {
  value = "${join(",",aws_instance.ec2-instance.*.primary_network_interface_id)}"
}
