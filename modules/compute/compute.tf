module "findami" {
  source = "./findami"
}

module "app" {
  source         = "./ec2-app"
  key_name       = "${var.region-key}"
  ami            = "${module.findami.amzami}"
  subnet-id      = "${var.private-subnet1-id}"
  security-group = ["${var.tfdemo-app-sg}"]
  az             = "${var.az1}"
  env            = "${var.env}"
  id             = "${var.id}"
  instance-count = "${var.app-instance-count}"
  instance-type  = "${var.app-instance-type}"
  region         = "${var.region}"
  ebs-size       = "${var.ebs-size}"
}

module "bastion" {
  source         = "./ec2-bastion"
  key_name       = "${var.region-key}"
  ami            = "${module.findami.amzami}"
  subnet-id      = "${var.public-subnet1-id}"
  security-group = ["${var.tfdemo-bastion-sg}"]
  az             = "${var.az1}"
  env            = "${var.env}"
  id             = "${var.id}"
  region         = "${var.region}"
}

module "buildeserver" {
  source         = "./ec2-buildserver"
  key_name       = "${var.region-key}"
  ami            = "${module.findami.amzami}"
  subnet-id      = "${var.public-subnet2-id}"
  security-group = ["${var.tfdemo-buildserver-sg}"]
  az             = "${var.az2}"
  env            = "${var.env}"
  id             = "${var.id}"
  region         = "${var.region}"
}