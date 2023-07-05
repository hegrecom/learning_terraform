terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix    = "terraform-up-and-running"
  engine               = "mysql"
  allocated_storage    = 10
  instance_class       = "db.t4g.micro"
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.example.name
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "example" {
  subnet_ids = [
    data.terraform_remote_state.vpc.outputs.private_subnet1_id,
    data.terraform_remote_state.vpc.outputs.private_subnet2_id,
  ]
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "${path.cwd}/../../vpc/terraform.tfstate"
  }
}
