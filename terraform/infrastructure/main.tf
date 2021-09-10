# ---------------------------------------------------------------------------------------------------------------------
# AWS PROVIDER FOR TF CLOUD
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = "~>0.14"
    backend "s3" {
      # Setting variables in the backend section isn't possible as of now, see https://github.com/hashicorp/terraform/issues/13022
      bucket = "terraform-backend-state-cc-cloud-bootstrap" # TODO: Investigate how to set dynamically
      encrypt = true
      dynamodb_table = "terraform-backend-lock-cc-cloud-bootstrap" # TODO: Investigate how to set dynamically
      key    = "terraform.tfstate"
      region = "eu-central-1"
    }
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}