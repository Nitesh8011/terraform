resource "aws_instance" "web-ec2" {
    ami = var.web_ec2_ami
    instance_type = var.web_instance_type_ami
}