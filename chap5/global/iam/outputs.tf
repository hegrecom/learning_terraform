output "first_arn" {
  value = aws_iam_user.example[0].arn
}

output "all_arn" {
  value = aws_iam_user.example[*].arn
}
