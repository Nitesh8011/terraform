provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_s3_bucket" "tf_state" {
  bucket = "terraform-state-232443791390"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "terraform_state_lock_table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}