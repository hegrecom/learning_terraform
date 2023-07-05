output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "vpc id"
}

output "private_subnet1_id" {
  value       = module.vpc.private_subnet1_id
  description = "private subnet1 id"
}

output "private_subnet2_id" {
  value       = module.vpc.private_subnet2_id
  description = "private subnet2 id"
}

output "public_subnet1_id" {
  value       = module.vpc.public_subnet1_id
  description = "public subnet1 id"
}

output "public_subnet2_id" {
  value       = module.vpc.public_subnet2_id
  description = "public subnet2 id"
}
