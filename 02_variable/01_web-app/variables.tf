variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type of ec2 instance"
}

variable "ami" {
    type = string
    default = "ami-00d8fc944fb171e29"
    description = "of ec2 instance"
}

variable "bucket_name" {
    type = string
    default = "web-app-s3-232443791390"
    description = "name of s3 bucket"
}

variable "db_identifier" {
    type = string
    default = "Name of rds instance"
}

variable "db_username" {
    type = string
    default = "postgres"
}

variable "db_password" {
    type = string
    sensitive = true
}