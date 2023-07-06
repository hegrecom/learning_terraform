provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_iam_user" "example" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

resource "aws_iam_user" "example_for_each" {
  for_each = toset(var.user_names_for_each)
  name     = each.value
}
