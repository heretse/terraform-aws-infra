locals {
  role_policies = flatten([
    for role in local.roles : [
      for inline_policy in lookup(role, "inline_policies", []) : {
        name      = inline_policy.name
        json_file = inline_policy.json_file
        role      = role.name
      }
    ]
  ])
}

resource "aws_iam_role_policy" "role_policies" {

  for_each = { for r in local.role_policies : "${r.role}:${r.name}" => r }

  name = each.value.name

  policy = file("${each.value.json_file}")

  role = each.value.role

  depends_on = [
    aws_iam_role.roles
  ]
}
