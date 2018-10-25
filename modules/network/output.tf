# VPC
output "vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "vpc_cidr" {
  value = "${module.vpc.vpc_cidr}"
}

output "private-subnet1-id" {
  value = "${module.private_subnet.private-subnet1}"
}

output "private-subnet2-id" {
  value = "${module.private_subnet.private-subnet2}"
}

output "public-subnet1-id" {
  value = "${module.public_subnet.public-subnet1}"
}

output "public-subnet2-id" {
  value = "${module.public_subnet.public-subnet2}"
}

output "tfdemo-buildserver-sg" {
  value = "${module.securitygroup.tfdemo-buildserver-sg}"
}

output "tfdemo-bastion-sg" {
  value = "${module.securitygroup.tfdemo-bastion-sg}"
}

output "tfdemo-app-sg" {
  value = "${module.securitygroup.tfdemo-app-sg}"
}
