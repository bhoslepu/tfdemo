variable "name" {
  default = "private"
}

variable "vpc_id" {}
variable "cidr-az1" {}
variable "az1" {}
variable "env" {}
variable "id" {}
variable "private_subnet_name-az1" {}
variable "private_subnet_name-az2" {}
variable "region" {}
variable "az2" {}
variable "cidr-az2" {}
variable "ngw-id" {}

resource "aws_subnet" "private-az1" {
  #region  = "${var.region}"  
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.cidr-az1}"
  availability_zone = "${var.az1}"

  tags {
    Name = "${var.env}-${var.id}-${var.private_subnet_name-az1}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "private-az2" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.cidr-az2}"
  availability_zone = "${var.az2}"

  tags {
    Name = "${var.env}-${var.id}-${var.private_subnet_name-az2}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#route_table creation

resource "aws_route_table" "private-rt" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${var.ngw-id}"
  }

  tags {
    Name = "${var.env}-${var.id}-routetable-private"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# AZ1 route_table association
resource "aws_route_table_association" "private-az1" {
  subnet_id      = "${aws_subnet.private-az1.id}"
  route_table_id = "${aws_route_table.private-rt.id}"

  lifecycle {
    create_before_destroy = true
  }
}

# AZ2 route_table association
resource "aws_route_table_association" "private-az2" {
  subnet_id      = "${aws_subnet.private-az2.id}"
  route_table_id = "${aws_route_table.private-rt.id}"

  lifecycle {
    create_before_destroy = true
  }
}

# Private RouteTable id
output "private_route-table" {
  value = "${aws_route_table.private-rt.id}"
}

output "private-subnet1" {
  value = "${aws_subnet.private-az1.id}"
}

output "private-subnet2" {
  value = "${aws_subnet.private-az2.id}"
}
