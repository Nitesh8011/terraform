resource "aws_db_instance" "database" {
    instance_class = var.db_instance_class
    allocated_storage = var.db_allocated_storage
    storage_type = "standard"
    engine = "postgres"
    engine_version = "16.8"
    identifer = var.db_identifer
    username = var.db_username
    password = var.db_password
    skip_final_snapshot = true
}