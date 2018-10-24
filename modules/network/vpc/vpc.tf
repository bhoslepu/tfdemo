#variable required for the vpc creation
variable "cidr" {}

variable "env" {}
variable "id" {}

#VPC creation block
resource "aws_vpc" "vpc" {
  cidr_block           = "${var.cidr}"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags {
    Name = "${var.env}-${var.id}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#output variable for out source the different resources
output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_cidr" {
  value = "${aws_vpc.vpc.cidr_block}"
}
