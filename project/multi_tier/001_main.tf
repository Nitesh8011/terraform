terraform {

  backend "s3" {
    bucket         = "terraform-state-232443791390"
    key            = "project/multi_tier/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform_state_lock_table"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27"
    }
  }
}

provider "aws" {
  region = var.region_name
}