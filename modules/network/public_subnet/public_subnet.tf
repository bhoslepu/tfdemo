variable "name" {
  default = "public"
}

variable "vpc_id" {}
variable "cidr-az1" {}
variable "az1" {}
variable "env" {}
variable "id" {}
variable "public_subnet_name-az1" {}
variable "az2" {}
variable "public_subnet_name-az2" {}
variable "cidr-az2" {}

resource "aws_internet_gateway" "public" {
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.name}"
  }
}

resource "aws_eip" "ngw-eip" {
  vpc   = true
  count = 1
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.ngw-eip.id}"
  subnet_id     = "${aws_subnet.public-az1.id}"

  tags {
    Name = "NAT GW"
  }

  depends_on = ["aws_internet_gateway.public"]
}

resource "aws_subnet" "public-az1" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.cidr-az1}"
  availability_zone = "${var.az1}"

  tags {
    Name = "${var.env}-${var.id}-${var.public_subnet_name-az1}"
  }

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = true
}

resource "aws_subnet" "public-az2" {
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${var.cidr-az2}"
  availability_zone = "${var.az2}"

  tags {
    Name = "${var.env}-${var.id}-${var.public_subnet_name-az2}"
  }

  lifecycle {
    create_before_destroy = true
  }

  map_public_ip_on_launch = true
}

#routetable creation
resource "aws_route_table" "public-rt" {
  vpc_id = "${var.vpc_id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.public.id}"
  }

  tags {
    Name = "${var.env}-${var.id}-rtable-public"
  }
}

#route table association
resource "aws_route_table_association" "public-az1" {
  subnet_id      = "${aws_subnet.public-az1.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

#route table association
resource "aws_route_table_association" "public-az2" {
  subnet_id      = "${aws_subnet.public-az2.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

#output public route table
output "public_route-table" {
  value = "${aws_route_table.public-rt.id}"
}

output "ngw-id" {
  value = "${aws_nat_gateway.natgw.id}"
}

output "public-subnet1" {
  value = "${aws_subnet.public-az1.id}"
}

output "public-subnet2" {
  value = "${aws_subnet.public-az2.id}"
}
