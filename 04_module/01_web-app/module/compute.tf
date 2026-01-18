resource "aws_instance" "instance_1" {
  ami = var.instance_ami
  instance_type = var.instance_type
  security_group = [aws_security_group.instance_sg.name]
  user_data              = <<-EOF
                                #!/bin/bash
                                apt-get update -y
                                apt-get install -y python3

                                mkdir -p /home/ubuntu/web
                                echo "Hello from Ubuntu EC2 1" > /home/ubuntu/web/index.html
                                chown -R ubuntu:ubuntu /home/ubuntu/web

                                cd /home/ubuntu/web
                                python3 -m http.server 8080 --bind 0.0.0.0 &
                                EOF
}


resource "aws_instance" "instance_2" {
  ami = var.instance_ami
  instance_type = var.instance_type
  security_group = [aws_security_group.instance_sg.name]
  user_data              = <<-EOF
                                #!/bin/bash
                                apt-get update -y
                                apt-get install -y python3

                                mkdir -p /home/ubuntu/web
                                echo "Hello from Ubuntu EC2 2" > /home/ubuntu/web/index.html
                                chown -R ubuntu:ubuntu /home/ubuntu/web

                                cd /home/ubuntu/web
                                python3 -m http.server 8080 --bind 0.0.0.0 &
                                EOF
}