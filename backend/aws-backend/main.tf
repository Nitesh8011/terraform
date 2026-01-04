terraform {

    # backend "s3" {
    #     bucket = "terraform-state-232443791390"
    #     key = "backend/aws-backend/terraform.tfstate"
    #     region = "ap-southeast-1"
    #     dynamodb_table = "terraform_state_lock_table"
    #     encrypt = true
    # }

    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = "~> 6.0"
        }
    }
}

provider "aws" {
    region = "ap-southeast-1"
}

resource "aws_s3_bucket" "terrafor_state" {
    bucket = "terraform-state-232443791390"    
    force_destroy = true
    versioning {
        enabled = true
    }
}

resource "aws_s3_bucket_versioning" "terraform_bucket_versioning" {
    bucket = aws_s3_bucket.terrafor_state.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terrafor_bucket_encryption" {
    bucket = aws_s3_bucket.terrafor_state.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

resource "aws_dynamodb_table" "terrafor_lock" {
    name = "terraform_state_lock_table"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
}