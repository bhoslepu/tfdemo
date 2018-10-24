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

output "petclinic-buildserver-sg" {
  value = "${module.securitygroup.petclinic-buildserver-sg}"
}

output "petclinic-bastion-sg" {
  value = "${module.securitygroup.petclinic-bastion-sg}"
}

output "petclinic-app-sg" {
  value = "${module.securitygroup.petclinic-app-sg}"
}
