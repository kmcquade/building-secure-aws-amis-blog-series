# ---------------------------------------------------------------------------------------------------------------------
# GENERAL
# These variables pass in general data from the calling module, such as the AWS Region and billing tags.
# ---------------------------------------------------------------------------------------------------------------------
variable "region" {
  default = "us-east-1"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATION TOGGLES
# Toogle to true to create resources
# ---------------------------------------------------------------------------------------------------------------------
variable "key_name" {
  description = "If no value is set, a key pair will be created for use in the bastion host."
  default     = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# RESOURCE VALUES
# These variables pass in actual values to configure resources. CIDRs, Instance Sizes, etc.
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# RESOURCE REFERENCES
# These variables pass in metadata on other existing AWS resources, such as ARNs, Names, etc.
# ---------------------------------------------------------------------------------------------------------------------
variable "ec2_ami_name_filter" {
  description = "AMI name filter to use in the data source lookup for AWS AMIs."
}

variable "allowed_inbound_cidr_blocks" {
  type = "list"
}

variable "availability_zone" {
  default     = "us-east-1a"
  description = "The first availability zone in us-east-1, unless otherwise specified."
}


variable "os_name" {
  default     = "centos"
  description = "The os targeted by this inspector instance. Can be one of [amazon_linux, amazon_linux_2_lts_2017_12, amazon_linux_2012_2014, amazon_linux_2015_2018, centos, generic, linux, debian, rhel, ubuntu, ubuntu_14_16_lts, ubuntu_18_04_lts, windows, windows_server_2008_2012, windows_server_2016_base]"
  type        = "string"
}

# ---------------------------------------------------------------------------------------------------------------------
# NAMING
# This manages the names of resources in this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "namespace" {
  description = "Namespace, which could be your organization name. First item in naming sequence."
}

variable "stage" {
  description = "Stage, e.g. `prod`, `staging`, `dev`, or `test`. Second item in naming sequence."
  default     = "dev"
}

variable "name" {
  description = "Name, which could be the name of your solution or app. Third item in naming sequence."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes, e.g. `1`"
}

variable "convert_case" {
  description = "Convert fields to lower case"
  default     = "true"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between (1) `namespace`, (2) `name`, (3) `stage` and (4) `attributes`"
}

variable "default_tags" {
  type        = "map"
  description = "Company Billing Tags."
}

# ---------------------------------------------------------------------------------------------------------------------
# NAMING PREFIXES
# This manages the naming prefixes in this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "security_group_name_prefix" {
  description = "The name prefix for security groups."
  default     = "sg"
}
