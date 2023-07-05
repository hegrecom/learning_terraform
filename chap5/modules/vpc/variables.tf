variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_public_subnet1_cidr_block" {
  description = "The CIDR block for the public subnet1"
  type        = string
}

variable "vpc_public_subnet2_cidr_block" {
  description = "The CIDR block for the public subnet2"
  type        = string
}

variable "vpc_private_subnet1_cidr_block" {
  description = "The CIDR block for the private subnet1"
  type        = string
}

variable "vpc_private_subnet2_cidr_block" {
  description = "The CIDR block for the private subnet2"
  type        = string
}
