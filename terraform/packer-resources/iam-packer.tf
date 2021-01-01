data "aws_iam_policy_document" "packer_ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

### Role Policy
data "aws_iam_policy_document" "packer_builder_role_policy" {
  statement {
    effect = "Allow"
    sid    = "GetVMImportBucket"
    actions = [
      "s3:Get*",
      "s3:List*",
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
    sid = "PackerSecurityGroupAccess"
    actions = [
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:DescribeSecurityGroups",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "PackerAMIAccess"
    actions = [
      "ec2:CreateImage",
      "ec2:RegisterImage",
      "ec2:DeregisterImage",
      "ec2:DescribeImages",
      "ec2:DescribeImageAttribute",
      "ec2:ModifyImageAttribute",
      "ec2:CopyImage",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "PackerSnapshotAccess"
    actions = [
      "ec2:CreateSnapshot",
      "ec2:DeleteSnaphot",
      "ec2:DescribeSnapshots",
      "ec2:ModifySnapshotAttribute",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "PackerInstanceAccess"
    actions = [
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:RebootInstances",
      "ec2:TerminateInstances",
      "ec2:DescribeInstances",
      "ec2:CreateTags",
      "ec2:ModifyInstanceAttribute",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "PackerKeyPairAccess"
    actions = [
      "ec2:CreateKeyPair",
      "ec2:DeleteKeyPair",
      "ec2:DescribeKeyPairs"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "PackerNetworking"
    actions = [
      "ec2:DescribeSubnets",
      "ec2:DescribeRegions",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "PackerVolumesAccess"
    actions = [
      "ec2:DetachVolume",
      "ec2:DescribeVolumes",
      "ec2:CreateVolume",
      "ec2:DeleteVolume",
      "ec2:AttachVolume"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  statement {
    sid = "PackerForWindows"
    actions = [
      "ec2:GetPasswordData",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  //  statement {
  //    sid = "PackerS3AllBucketsAccess"
  //    actions = [
  //      "s3:Get*",
  //      "s3:List*",
  //      "s3:PutObject*",
  //      "s3:DeleteObject*"
  //    ]
  //    resources = ["*"]
  //    effect = "Allow"
  //  }
}

resource "aws_iam_role" "packer_builder_role" {
  name               = var.packer_role_name
  assume_role_policy = data.aws_iam_policy_document.packer_ec2_assume_role.json
}

resource "aws_iam_policy" "packer_builder_role" {
  name   = var.packer_policy_name
  policy = data.aws_iam_policy_document.packer_builder_role_policy.json
}

resource "aws_iam_policy_attachment" "packer_builder_role" {
  name       = var.packer_policy_name
  roles      = [aws_iam_role.packer_builder_role.name]
  policy_arn = aws_iam_policy.packer_builder_role.arn
}

resource "aws_iam_instance_profile" "packer_builder_instance_profile" {
  name = var.packer_role_name
  role = aws_iam_role.packer_builder_role.name
}
