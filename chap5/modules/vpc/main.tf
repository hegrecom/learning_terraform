terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.vpc_cidr_block
}
resource "aws_internet_gateway" "terraform_gateway" {
  vpc_id = aws_vpc.terraform_vpc.id
}

resource "aws_subnet" "terraform_public_subnet1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.vpc_public_subnet1_cidr_block
  availability_zone = "ap-northeast-2a"
}

resource "aws_subnet" "terraform_public_subnet2" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.vpc_public_subnet2_cidr_block
  availability_zone = "ap-northeast-2b"
}

resource "aws_subnet" "terraform_private_subnet1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.vpc_private_subnet1_cidr_block
  availability_zone = "ap-northeast-2a"
}

resource "aws_subnet" "terraform_private_subnet2" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = var.vpc_private_subnet2_cidr_block
  availability_zone = "ap-northeast-2b"
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_gateway.id
  }
}

resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = aws_subnet.terraform_public_subnet1.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "public_subnet2_association" {
  subnet_id      = aws_subnet.terraform_public_subnet2.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}
