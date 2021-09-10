# ---------------------------------------------------------------------------------------------------------------------
# Terraform Remote State Resources (S3 bucket for state, DynamoDB table for lock)
# Apply first before initializing any project resources
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = "~>0.14"
}

provider "aws" {
  region = var.aws_region
  profile = var.aws_profile
}

resource "aws_s3_bucket" "terraform-backend-state" {
  bucket = "terraform-backend-state-${var.project}"
  acl = "private"
  versioning {
    enabled = true
  }
  tags = {
    Name = "${var.stack}-Terraform-Remote-State-S3"
    Project = var.project
  }
}

resource "aws_dynamodb_table" "terraform-backend-lock" {
  name = "terraform-backend-lock-${var.project}"
  hash_key = "LockID"
  read_capacity = 5
  write_capacity = 5
  attribute {
    name = "LockID" # Must match exactly this name, otherwise locking will fail
    type = "S"
  }
  tags = {
    Name = "${var.stack}-Terraform-Remote-State-DynamoDb"
    Project = var.project
  }
}