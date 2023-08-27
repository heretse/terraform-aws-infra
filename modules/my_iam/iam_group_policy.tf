locals {
  group_policies = flatten([
    for group in local.groups : [
      for inline_policy in lookup(group, "inline_policies", []) : {
        name      = inline_policy.name
        json_file = inline_policy.json_file
        group     = group.name
      }
    ]
  ])
}

resource "aws_iam_group_policy" "group_policies" {

  for_each = { for r in local.group_policies : "${r.group}:${r.name}" => r }

  name = each.value.name

  policy = file("${each.value.json_file}")

  group = each.value.group

  depends_on = [
    aws_iam_group.groups
  ]
}
