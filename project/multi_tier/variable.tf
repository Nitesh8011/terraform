variable "region_name" {
  default     = "ap-southeast-1"
  description = "AWS Region Name"
}

variable "cidr_block_vpc" {
  default     = "10.20.0.0/16"
  description = "VPC CIDR block range"
}

variable "cidr_block_pub_sb_1" {
  default = "10.20.1.0/24"
}

variable "pub_sub_1_az" {
  default = "ap-southeast-1a"
}

variable "cidr_block_pub_sb_2" {
  default = "10.20.2.0/24"
}

variable "pub_sub_2_az" {
  default = "ap-southeast-1b"
}

variable "cidr_block_pri_sb_1" {
  default = "10.20.3.0/24"
}

variable "priv_sub_1_az" {
  default = "ap-southeast-1a"
}

variable "cidr_block_pri_sb_2" {
  default = "10.20.4.0/24"
}

variable "priv_sub_2_az" {
  default = "ap-southeast-1b"
}

variable "web_ec2" {
  default = "ami-00d8fc944fb171e29"
}

variable "web_instance_type_ami" {
  default = "t3.micro"
}