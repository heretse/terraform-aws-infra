locals {
  group_policy_association_list = flatten([
    for group in local.groups : [
      for policy_arn in lookup(group, "policy_arns", []) : {
        group      = group.name
        policy_arn = policy_arn
      }
    ]
  ])
}

resource "aws_iam_group_policy_attachment" "attachments" {

  for_each = { for r in local.group_policy_association_list : "${r.group}/${r.policy_arn}" => r }

  policy_arn = each.value.policy_arn
  group      = each.value.group

  depends_on = [
    aws_iam_policy.policies,
    aws_iam_group.groups
  ]
}
