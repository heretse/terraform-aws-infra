locals {
  # user_policies = [for user in local.users : { "name" : user.inline_policy.name, "json_file" : user.inline_policy.json_file, "user" : user.name } if lookup(user, "inline_policy", null) != null]

  user_policies = flatten([
    for user in local.users : [
      for inline_policy in lookup(user, "inline_policies", []) : {
        name      = inline_policy.name
        json_file = inline_policy.json_file
        user      = user.name
      }
    ]
  ])
}

resource "aws_iam_user_policy" "user_policies" {

  for_each = { for r in local.user_policies : "${r.user}:${r.name}" => r }

  name = each.value.name

  policy = file("${each.value.json_file}")

  user = each.value.user

  depends_on = [
    aws_iam_user.users
  ]
}
