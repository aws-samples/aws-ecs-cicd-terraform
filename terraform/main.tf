# ---------------------------------------------------------------------------------------------------------------------
# AWS PROVIDER FOR TF CLOUD
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = "~>0.12"
    backend "s3" {
      bucket = "terraform-backend-state" # Supply via var?
      dynamodb_table = "terraform-backend-lock" # Supply via var?
      key    = "terraform.tfstate"
      region = "eu-central-1"
    }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}