# ---------------------------------------------------------------------------------------------------------------------
# CREATE BASTION HOST
# ---------------------------------------------------------------------------------------------------------------------

module "ec2_bastion" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ec2-instance?ref=v1.19.0"

  name           = "${module.bastion_label.id}"
  instance_count = 1
  ami            = "${data.aws_ami.centos.id}"
  instance_type  = "t2.medium"
  key_name       = "${var.key_name == "" ? module.ssh_keypair.name : var.key_name}"

  //  iam_instance_profile = "${module.ecs_iam_jenkins_master.ec2_instance_profile_name}"
  subnet_id                   = "${data.aws_subnet.default.id}"
  user_data                   = "${file("${path.module}/userdata.sh")}"
  associate_public_ip_address = true

  vpc_security_group_ids = ["${aws_security_group.ssh.id}"]

  tags = "${merge(map("Name", "${module.bastion_label.id}"), var.default_tags)}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE SSH KEY PAIR
# Only if one is not provided.
# ---------------------------------------------------------------------------------------------------------------------

module "ssh_keypair" {
  source = "git::https://github.com/hashicorp-modules/ssh-keypair-aws.git?ref=v0.2.1"
  create = "${var.key_name == "" ? 1 : 0}"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE SECURITY GROUP TO MANAGE SSH TRAFFIC FROM YOUR IP ADDRESS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "ssh" {
  vpc_id      = "${data.aws_vpc.default.id}"
  name        = "${module.sg_internal_traffic_label.id}"
  description = "Allow all ingress to self, and egress to everywhere."
  tags        = "${module.sg_internal_traffic_label.tags}"
}

resource "aws_security_group_rule" "ingress" {
  from_port         = 22
  protocol          = "-1"
  security_group_id = "${aws_security_group.ssh.id}"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["${var.allowed_inbound_cidr_blocks}", "${data.aws_vpc.default.cidr_block}"]
}

resource "aws_security_group_rule" "allow_all_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  security_group_id = "${aws_security_group.ssh.id}"
  cidr_blocks       = ["0.0.0.0/0"]
}
