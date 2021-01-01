module "sg_internal_traffic_label" {
  source       = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.4.0"
  namespace    = "${var.security_group_name_prefix}"
  stage        = "${var.stage}"
  name         = "${var.name}"
  attributes   = ["external", "traffic"]
  delimiter    = "_"
  tags         = "${var.default_tags}"
  convert_case = "false"
}


module "bastion_label" {
  source       = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.4.0"
  namespace    = "${var.namespace}"
  stage        = "${var.stage}"
  name         = "Bastion"
  delimiter    = "-"
  convert_case = "true"
  tags         = "${var.default_tags}"
  enabled      = "true"
}
