terraform {
    backend "s3" {
        bucket          = "terraform-state-232443791390"
        key             = "02_variable/00_example/terraform.tfstate"
        region          = "ap-southeast-1"
        dynamodb_table  = "terraform_state_lock_table"
        encrypt         = true
    }

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

locals {
    extra_tag = "extra-tags"
}

resource "aws_instance" "instance_1" {
    ami             = var.ami
    instance_type   = var.instance_type

    tags = {
        Name = var.instance_name
        ExtraTag = local.extra_tag
    }
}

# resource "aws_db_instance" "db_instance" {
#     identifier           = "variable-rds"
#     allocated_storage   = 10
#     storage_type        = "gp3"
#     engine              = "postgres"
#     engine_version      = "16.8"
#     instance_type       = "db.t2.micro"
#     name                = "postgres"
#     username            = var.db_username
#     password            = var.db_password
#     skip_final_snapshot  = true
# }