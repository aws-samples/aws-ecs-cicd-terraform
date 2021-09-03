# ---------------------------------------------------------------------------------------------------------------------
# Terraform Remote State Resources (S3 bucket for state, DynamoDB table for lock)
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_s3_bucket" "terraform-backend-state" {
  bucket = "terraform-backend"
  acl = "private"
  versioning {
    enabled = true
  }
}

resource "aws_dynamodb_table" "terraform-backend-lock" {
  name = "terraform-backend-lock"
  hash_key = "LockId"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockId"
    type = "S"
  }
}