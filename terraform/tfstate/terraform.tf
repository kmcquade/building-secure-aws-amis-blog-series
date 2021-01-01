terraform {
  required_version = ">= 0.12.28"
  backend "s3" {
    region         = "us-east-1"
    bucket         = "namespace-stage-name-tfstate" # TODO: Insert the name of your s3 bucket
    key            = "us-east-1/packer-resources/terraform.tfstate"
    dynamodb_table = "namespace-stage-name-terraform-state-lock" # TODO: Insert the name of your DynamoDB table
    encrypt        = true
  }
}