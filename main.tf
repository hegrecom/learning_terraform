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

resource "aws_route_table" "public_subnet1_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_gateway.id
  }
}

resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = aws_subnet.terrafrom_public_subnet1.id
  route_table_id = aws_route_table.public_subnet1_route_table.id
}

resource "aws_security_group" "allow_8080" {
  name        = "allow_8080"
  description = "allow all traffic from port 8080"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description = "All traffic from port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All traffic to port 0"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "allow ssh"
  vpc_id      = aws_vpc.terraform_vpc.id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_key_pair" "terrafrom_key" {
  key_name           = "terraform"
  include_public_key = true
}

resource "aws_instance" "example" {
  ami                         = "ami-0c9c942bd7bf113a2"
  instance_type               = "t3.nano"
  subnet_id                   = aws_subnet.terrafrom_public_subnet1.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_8080.id, aws_security_group.allow_ssh.id]
  key_name                    = data.aws_key_pair.terrafrom_key.key_name
  user_data                   = <<-EOF
                                #!/bin/bash
                                echo "Hello, World" > index.html
                                nohup busybox httpd -f -p 8080 &
                                EOF
  user_data_replace_on_change = true
  tags = {
    Name = "terraform-example"
  }
}
