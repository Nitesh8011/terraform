terraform {
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

resource "aws_instance" "first_ec2" {
    ami = "ami-00d8fc944fb171e29"
    instance_type = "t2.nano"
}