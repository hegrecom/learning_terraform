output "user_arns" {
  value = values(module.users)[*].user_arn
}
