provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block = "172.16.0.0/16"
}
resource "aws_internet_gateway" "terraform_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id
}

resource "aws_subnet" "terrafrom_public_subnet1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "172.16.0.0/24"
  availability_zone = "ap-northeast-2a"
}

resource "aws_subnet" "terrafrom_public_subnet2" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "172.16.1.0/24"
  availability_zone = "ap-northeast-2b"
}

resource "aws_subnet" "terraform_private_subnet1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "172.16.128.0/24"
  availability_zone = "ap-northeast-2a"
}

resource "aws_subnet" "terraform_private_subnet2" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "172.16.129.0/24"
  availability_zone = "ap-northeast-2a"
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_gateway.id
  }
}

resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = aws_subnet.terrafrom_public_subnet1.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "public_subnet2_association" {
  subnet_id      = aws_subnet.terrafrom_public_subnet2.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_security_group" "allow_server_port" {
  name        = "allow_server_port"
  description = "allow all traffic from server port"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description = "All traffic from server_port"
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "server_port" {
  description = "server port number"
  type        = number
  default     = 8080
}

resource "aws_launch_configuration" "terraform_example" {
  image_id                    = "ami-0c9c942bd7bf113a2"
  instance_type               = "t3.nano"
  associate_public_ip_address = true
  security_groups             = [aws_security_group.allow_server_port.id]
  user_data                   = <<-EOF
                                #!/bin/bash
                                echo "Hello, World" > index.html
                                nohup busybox httpd -f -p ${var.server_port} &
                                EOF
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "terraform_example" {
  launch_configuration = aws_launch_configuration.terraform_example.name
  min_size             = 2
  max_size             = 10
  vpc_zone_identifier = [
    aws_subnet.terraform_private_subnet1.id,
    aws_subnet.terraform_private_subnet2.id
  ]
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "alb" {
  name   = "terraform_lb"
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "terraform_lb" {
  name               = "terraform-asg-example"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.terrafrom_public_subnet1.id,
    aws_subnet.terrafrom_public_subnet2.id
  ]
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.terraform_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-example"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform_vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 15
    matcher             = "200"
    path                = "/"
    port                = var.server_port
    protocol            = "HTTP"
  }

}

output "alb_dns_name" {
  value       = aws_lb.terraform_lb.dns_name
  description = "The DNS name of the load balancer"
}
