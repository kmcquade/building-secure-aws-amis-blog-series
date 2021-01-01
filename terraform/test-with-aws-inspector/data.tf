data "aws_region" "current" {}

data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ec2_ami_name_filter}"]
  }

  owners = ["self"]
}

# Looks up the default VPC ID.
# Default VPC is okay since we are using it for testing purposes only in a testing environment.
data "aws_vpc" "default" {
  default = true
  state   = "available"
}

# Looks up the public subnet in the default VPC.
# This is okay since we are just using it for testing purposes in a testing environment.
data "aws_subnet" "default" {
  vpc_id            = "${data.aws_vpc.default.id}"
  state             = "available"
  default_for_az    = true
  availability_zone = "${var.availability_zone}"
}
