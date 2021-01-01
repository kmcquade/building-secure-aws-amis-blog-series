module "inspector_label" {
  source       = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.2.1"
  namespace    = "${var.namespace}"
  stage        = "${var.stage}"
  name         = "${var.name}"
  attributes   = ["inspector","scan"]
  delimiter    = "${var.delimiter}"
  convert_case = "${var.convert_case}"
  tags         = "${var.default_tags}"
  enabled      = "true"
}

resource "aws_inspector_resource_group" "inspector" {
  tags = {
    Name = "${module.bastion_label.id}"
  }
}

resource "aws_inspector_assessment_target" "inspector" {
  name               = "${module.inspector_label.id}"
  resource_group_arn = "${aws_inspector_resource_group.inspector.arn}"
}

resource "aws_inspector_assessment_template" "template" {
  duration            = "900" # 15 minutes
  name                = "${module.inspector_label.id}"
  rules_package_arns  = ["${local.rules_package_arns}"]
  target_arn          = "${aws_inspector_assessment_target.inspector.arn}"
}

# Borrowed this structure from https://github.com/QuiNovas/terraform-aws-inspector/blob/master/locals.tf
locals {
  os_rules_package_arns = {
        centos                      = [
      "${lookup(local.regional_rules_package_arns[data.aws_region.current.name],"common_vulnerabilities_and_exposures")}",
      "${lookup(local.regional_rules_package_arns[data.aws_region.current.name],"cis_operating_system_security_configuration_benchmarks")}",
//      "${lookup(local.regional_rules_package_arns[data.aws_region.current.name],"security_best_practices")}",
//      "${lookup(local.regional_rules_package_arns[data.aws_region.current.name],"runtime_behavior_analysis")}"
    ]
  }
  # Account numbers: https://docs.aws.amazon.com/inspector/latest/userguide/inspector_agents.html#access-control
  # https://docs.aws.amazon.com/inspector/latest/userguide/inspector_rules-arns.html#us-east-1
  regional_rules_package_arns               = {
    us-east-1 = {
      common_vulnerabilities_and_exposures                    = "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gEjTy7T7"
      cis_operating_system_security_configuration_benchmarks  = "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-rExsr2X8"
      security_best_practices                                 = "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-R01qwB5Q"
      runtime_behavior_analysis                               = "arn:aws:inspector:us-east-1:316112463485:rulespackage/0-gBONHN9h"
    }
  }
    rules_package_arns                        = [
    "${local.os_rules_package_arns[var.os_name]}"
  ]

}
