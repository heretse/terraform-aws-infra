locals {
  user_groups = yamldecode(file("${var.iam_path}"))["users"]
}

resource "aws_iam_user_group_membership" "user_groups" {

  for_each = { for r in local.user_groups : r.name => r if length(r.groups) > 0 }

  groups = each.value.groups
  user   = each.value.name

  depends_on = [
    aws_iam_user.users
  ]
}
