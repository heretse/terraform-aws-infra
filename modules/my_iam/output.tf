output "iam_group_arn" {
  value = aws_iam_group.groups
}

output "iam_role_arn" {
  value = aws_iam_role.roles
}

output "iam_user_arn" {
  value = aws_iam_user.users
}
