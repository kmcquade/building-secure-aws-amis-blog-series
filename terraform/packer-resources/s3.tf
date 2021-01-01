module "s3_label" {
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

resource "aws_s3_bucket" "vmimport" {
  bucket        = module.s3_label.id
  acl           = "private"
  region        = var.region
  force_destroy = var.force_destroy
  policy        = var.policy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = var.sse_algorithm
        kms_master_key_id = var.kms_master_key_id
      }
    }
  }

  tags = module.s3_label.tags
}
