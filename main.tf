provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_vpc" "terraform_vpc" {
  cidr_block = "172.16.0.0/16"
}

resource "aws_subnet" "terrafrom_private_subnet1" {
  vpc_id            = aws_vpc.terraform_vpc.id
  cidr_block        = "172.16.0.0/24"
  availability_zone = "ap-northeast-2a"
}

resource "aws_instance" "example" {
  ami           = "ami-0bd21253724ee935b"
  instance_type = "t4g.nano"
  subnet_id     = aws_subnet.terrafrom_private_subnet1.id
  tags = {
    Name = "terraform-example"
  }
}
