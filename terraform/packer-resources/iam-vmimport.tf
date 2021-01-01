module "vmimport_iam_label" {
  source       = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=0.4.0"
  namespace    = var.namespace
  stage        = var.stage
  name         = var.name
  attributes   = [compact(var.attributes)]
  delimiter    = var.delimiter
  convert_case = var.convert_case
  tags         = var.default_tags
  enabled      = "true"
}

data "aws_iam_policy_document" "vmimport_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["vmie.amazonaws.com"]
    }
    condition {
      test = "StringEquals"
      values = ["vmimport"]
      variable = "sts:Externalid"
    }
  }
}

resource "aws_iam_role" "vmimport_role" {
  name = module.vmimport_iam_label.id
  assume_role_policy = data.aws_iam_policy_document.vmimport_assume_role.json
}

### Role Policy
data "aws_iam_policy_document" "vmimport_role_policy" {
  statement {
    effect = "Allow"
    sid = "GetVMImportBucket"
    actions = [
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.vmimport.arn,
      "${aws_s3_bucket.vmimport.arn}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:ModifySnapshotAttribute",
      "ec2:CopySnapshot",
      "ec2:RegisterImage",
      "ec2:Describe*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "vm_import_policy" {
  name = module.vmimport_iam_label.id
  policy = data.aws_iam_policy_document.vmimport_role_policy.json
}

resource "aws_iam_policy_attachment" "vmimport_role" {
  name = module.vmimport_iam_label.id
  roles = [aws_iam_role.vmimport_role.name]
  policy_arn = aws_iam_policy.vm_import_policy.arn
}