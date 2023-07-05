terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr_block                 = "172.16.0.0/16"
  vpc_public_subnet1_cidr_block  = "172.16.1.0/24"
  vpc_public_subnet2_cidr_block  = "172.16.2.0/24"
  vpc_private_subnet1_cidr_block = "172.16.128.0/24"
  vpc_private_subnet2_cidr_block = "172.16.129.0/24"
}
