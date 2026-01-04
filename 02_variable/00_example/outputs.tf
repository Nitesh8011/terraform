output "instance_private_ip_addr" {
    value = aws_instance.instance_1.private_ip
}

output "instance_public_ip_addr" {
    value = aws_instance.instance_1.public_ip
}

# output "db_instance_addr" {
#     value = aws_db_instance.db_instance.address
# }