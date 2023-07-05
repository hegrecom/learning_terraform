output "vpc_id" {
  value       = aws_vpc.terraform_vpc.id
  description = "vpc id"
}

output "private_subnet1_id" {
  value       = aws_subnet.terraform_private_subnet1.id
  description = "private subnet1 id"
}

output "private_subnet2_id" {
  value       = aws_subnet.terraform_private_subnet2.id
  description = "private subnet2 id"
}

output "public_subnet1_id" {
  value       = aws_subnet.terraform_public_subnet1.id
  description = "public subnet1 id"
}

output "public_subnet2_id" {
  value       = aws_subnet.terraform_public_subnet2.id
  description = "public subnet2 id"
}
