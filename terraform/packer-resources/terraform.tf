terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "namespace-dev-terraform-tfstate" # TODO
    key            = "packer-resources/terraform.tfstate"
    dynamodb_table = "namespace-dev-terraform-tfstate-lock" # TODO
    encrypt        = true
  }
  required_version = "~> 0.12.28"
}

# terraform and provider configuration
provider "aws" {
  region  = var.region
  version = ">= 2.0.0"
}
