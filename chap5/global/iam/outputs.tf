output "first_arn" {
  value = aws_iam_user.example[0].arn
}

output "all_arn" {
  value = aws_iam_user.example[*].arn
}

output "all_users" {
  value = aws_iam_user.example_for_each
}

output "all_arns_for_each" {
  value = values(aws_iam_user.example_for_each)[*].arn
}

output "upper_names" {
  value = [for name in var.user_names_for_each : upper(name)]
}

output "short_upper_names" {
  value = [for name in var.user_names_for_each : upper(name) if length(name) < 5]
}

output "bios" {
  value = [for name, role in var.hero_thousand_faces : "${name} is the ${role}"]
}

output "upper_roles" {
  value = { for name, role in var.hero_thousand_faces : upper(name) => upper(role) }
}

output "for_directives" {
  value = "%{for name in var.user_names_for_each}${name}, %{endfor}"
}

output "for_directives_index" {
  value = "%{for i, name in var.user_names_for_each}(${i}) ${name}, %{endfor}"
}

output "neo_cloudwatch_policy_arn" {
  value = one(concat(aws_iam_user_policy_attachment.neo_cloudwatch_full_access[*].policy_arn, aws_iam_user_policy_attachment.neo_cloudwatch_read_only[*].policy_arn))
}
