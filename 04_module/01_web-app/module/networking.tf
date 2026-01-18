data "aws_vpc" "default_vpc" {
    default = true
}

data "aws_subnet" "default_subnet" {
    vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_security_group" "instance_sg" {
    name = "${var.app_name}-${var.env_name}-instance-sg"
}

resource "aws_security_group_rule" "aws_instance_sg_allow_rule" {
    type = "ingress"
    security_group_id = aws_security_group.instance_sg.id

    from_port = "8080"
    to_port = "8080"
    protocol ="tcp"
    cidr = ["0.0.0.0/0"]
}

resource "aws_lb" "application_lb" {
    name = "${var.app_name}-${var.env_name}-lb"
    internal = false
    load_balancer_type = "application"
    security_group = aws_security_group_rule.alb_sg.id
    subnet = data.aws_subnet.default_subnet.ids
}

resource "aws_security_group" "alb_sg" {
    name = "${var.app_name}-${var.env_name}-alb-sg"
}

resource "aws_security_group_rule" "aws_alb_sg_allow_rule" {
    type = "ingress"
    security_group_id = aws_security_group.alb_sg.id

    from_port = "80"
    to_port = "80"
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "tcp"
}

resource "aws_security_group" "aws_alb_sg_deny_rule" {
    type = "egress"
    security_group_id = aws_security_group.alb_sg.id

    to_port = "0"
    from_port = "0"
    cidr_blocks = ["0.0.0.0/0"]
    protocol = "-1"
}

resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.application_lb.arn
    port = "80"
    protocol = "http"

    default_action {
        type = "fixed-response"
        fixed_response {
            content_type = "text/plan"
            message_body = "404: Not Found"
            status_code = 404
        }
    }
}

resource "aws_lb_target_group" "aws_lb_tg" {
    name = "${var.app_name}-${var.env_name}-tg"
    port = 8080
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
        path = "/"
        protocol = "HTTP"
        matcher = 200
        internal = 30
        timeout = 5
        healthy_threshold = 2
        failure_threshold = 2
    }
}

resource "aws_lb_target_group_attachment" "instance_lb_tg_1" {
    target_group_arn = aws_lb_target_group.aws_lb_tg.arn
    target_id = aws_instance.instance_1.id
    port = 8080
}

resource "aws_lb_target_group_attachment" "instance_lb_tg_2" {
    target_group_arn = aws_lb_target_group.aws_lb_tg.arn
    target_id = aws_instance.instance_2.id
    port = 8080
}

resource "aws_lb_listener_rule" "instance" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100

    condition {
        path_pattern {
            values = ["*"]
        }
    }
    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.aws_lb_tg.arn
    }
}