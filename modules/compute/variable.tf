variable "name" {
  default = "tfdemo"
}

variable "ebs-size" {}

variable "az1" {}

variable "az2" {}

variable "region" {}

variable "region-key" {}

variable "env" {}
variable "id" {}
variable "private-subnet1-id" {}
variable "private-subnet2-id" {}
variable "public-subnet1-id" {}
variable "public-subnet2-id" {}
variable "app-instance-count" {}
variable "app-instance-type" {}
variable "tfdemo-app-sg" {}
variable "tfdemo-bastion-sg" {}
variable "tfdemo-buildserver-sg" {}
