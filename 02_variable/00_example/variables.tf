variable "instance_name" {
    description = "name of instance"
    type = string
    default = "instance-var-from-variable-tf"
}

variable "ami" {
    description = "Amazon machine image to use for ec2 instance"
    type = string
    default = "ami-00d8fc944fb171e29"
}

variable "instance_type" {
    description = "Instance type of ec2 instance"
    type = string
    default = "t3.micro"
}

variable "db_username" {
    description = "username of database"
    type = string
    default = "rds_master"
}

variable "db_password" {
    description = "password of database"
    type = string
    sensitive = true
}