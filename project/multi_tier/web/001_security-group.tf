resource "aws_security_group" "public_alb_sg" {
    name = "public-sg"
    vpc_id = aws_vpc.project_vpc.id
    tags = {
        name = "public-sg"
    }
}

resource "aws_security_group_rule" "public_alb_sg_ingress" {
    type = "ingress"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.public_alb_sg.id
}

resource "aws_security_group_rule" "public_alb_sg_egress" {
    type = "egress"
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.public_alb_sg.id
}

resource "aws_lb" "public_lb" {
    name = "public-lb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.public_alb_sg.id]
    subnets = [
        aws_subnet.pub_sb_1.id,
        aws_subnet.pub_sb_2.id
    ]
}