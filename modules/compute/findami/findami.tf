#variable search_ami {}
data "aws_ami" "amz-ami" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  owners = ["amazon"]
}

output "amzami" {
  value = "${data.aws_ami.amz-ami.image_id}"
}
