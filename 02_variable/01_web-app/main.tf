terraform {
    backend "s3" {
        bucket          = "terraform-state-232443791390"
        key             = "02_variable/01_web-app/terraform.tfstate"
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

resource "aws_instance" "instance_1" {
    ami             = var.ami
    instance_type   = var.instance_type
    vpc_security_group_ids  = [aws_security_group.web_app_sg.id]
    user_data               = <<-EOF
                                #!/bin/bash
                                apt-get update -y
                                apt-get install -y python3

                                mkdir -p /home/ubuntu/web
                                echo "Hello from Ubuntu EC2" > /home/ubuntu/web/index.html
                                chown -R ubuntu:ubuntu /home/ubuntu/web

                                cd /home/ubuntu/web
                                python3 -m http.server 8080 --bind 0.0.0.0 &
                                EOF
}

resource "aws_instance" "instance_2" {
    ami                     = var.ami
    instance_type           = var.instance_type
    vpc_security_group_ids  = [aws_security_group.web_app_sg.id]
    user_data               = <<-EOF
                                #!/bin/bash
                                apt-get update -y
                                apt-get install -y python3

                                mkdir -p /home/ubuntu/web
                                echo "Hello from Ubuntu EC2-2" > /home/ubuntu/web/index.html
                                chown -R ubuntu:ubuntu /home/ubuntu/web

                                cd /home/ubuntu/web
                                python3 -m http.server 8080 --bind 0.0.0.0 &
                                EOF
}

resource "aws_s3_bucket" "web_app_s3_bucket" {
    bucket          = var.bucket_name
    force_destroy   = true
}

resource "aws_s3_bucket_versioning" "web_app_s3_versioning" {
    bucket = aws_s3_bucket.web_app_s3_bucket.id
    versioning_configuration {
        status = "Enabled"    
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "web_app_s3_encryption" {
    bucket = aws_s3_bucket.web_app_s3_bucket.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

data "aws_vpc" "default"  {
    default = "true"
}

data "aws_subnets" "default_subnets" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
    filter {
        name = "default-for-az"
        values = ["true"]
    }
}

resource "aws_security_group" "web_app_sg" {
    name        = "web-app-sg"
    description = "security group for web-app"
}

resource "aws_security_group_rule" "allow_http_inbound" {
    type                = "ingress"
    from_port           = 8080
    to_port             = 8080
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.web_app_sg.id
}


resource "aws_security_group_rule" "allow_alb_http_inbound" {
    type                = "ingress"
    from_port           = 8080
    to_port             = 8080
    protocol            = "tcp"
    cidr_blocks         = ["172.31.0.0/16"]
    security_group_id   = aws_security_group.web_app_sg.id
}

resource "aws_security_group_rule" "allow_ssh_inbound" {
    type                = "ingress"
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.web_app_sg.id
}

resource "aws_security_group_rule" "allow_web_app_http_outbound" {
    type                = "egress"
    from_port           = 8080
    to_port             = 8080
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.web_app_sg.id
}

resource "aws_lb" "loadbalancer_wep_app" {
    name                        = "web-app-lb"
    internal                    = false
    load_balancer_type          = "application"
    security_groups             = [aws_security_group.alb_sg.id]
    subnets                     = data.aws_subnets.default_subnets.ids
}

resource "aws_security_group" "alb_sg" {
    name = "alb-web-app-sg"
}

resource "aws_security_group_rule" "allow_alb_http_inbount" {
    type                = "ingress"
    security_group_id   = aws_security_group.alb_sg.id
    from_port           = 80
    to_port             = 80
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow_alb_http_outbound" {
    type                = "egress"
    security_group_id   = aws_security_group.alb_sg.id
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]
}

resource "aws_lb_listener" "http" {
    load_balancer_arn   = aws_lb.loadbalancer_wep_app.arn
    port                = 80
    protocol            = "HTTP"

    default_action {
        type = "fixed-response"

        fixed_response {
            content_type    = "text/plain"
            message_body    = "404: Page Not Found"
            status_code     = 404
        }
    }
}

resource "aws_lb_target_group" "wep_app_lb_tg" {
    name        = "web-app-tg"
    port        = 8080
    protocol    = "HTTP"
    vpc_id      = data.aws_vpc.default.id

    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = 200
        interval            = 15
        timeout             = 3
        healthy_threshold   = 2
        unhealthy_threshold = 2
    } 
}

resource "aws_lb_target_group_attachment" "web_app_tg_attach_1" {
    target_group_arn    = aws_lb_target_group.wep_app_lb_tg.arn
    target_id           = aws_instance.instance_1.id
    port                = 8080
}

resource "aws_lb_target_group_attachment" "web_app_tg_attach_2" {
    target_group_arn    = aws_lb_target_group.wep_app_lb_tg.arn
    target_id           = aws_instance.instance_2.id
    port                = 8080
}

resource "aws_lb_listener_rule" "instances" {
    listener_arn    = aws_lb_listener.http.arn
    priority        = 100

    condition {
        path_pattern {
            values = ["*"]
        }
    }
    action {
        type                = "forward"
        target_group_arn    = aws_lb_target_group.wep_app_lb_tg.arn
    }
}

resource "aws_db_instance" "web_app_rds" {
    identifier           = var.db_identifier
    allocated_storage   = 10
    db_name             = "webapprds"
    engine              = "postgres"
    engine_version      = 16
    instance_class      = "db.t3.micro"
    username            = var.db_username
    password            = var.db_password
    skip_final_snapshot  = true
}