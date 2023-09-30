locals {
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
  # checkov:skip=CKV_AWS_40: "Ensure IAM policies are attached only to groups or roles (Reducing access management complexity may in-turn reduce opportunity for a principal to inadvertently receive or retain excessive privileges.)"

  for_each = { for r in local.user_policies : "${r.user}:${r.name}" => r }

  name = each.value.name

  policy = file("${each.value.json_file}")

  user = each.value.user

  depends_on = [
    aws_iam_user.users
  ]
}
