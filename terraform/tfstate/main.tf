module "terraform_state_backend" {
  source     = "git::https://github.com/cloudposse/terraform-aws-tfstate-backend.git?ref=0.9.0"
  namespace  = "namespace"
  stage      = "dev"
  name       = "terraform"
  attributes = ["tfstate"]
  region     = "us-east-1"
}
