
locals {
  role_policy_association_list = flatten([
    for role in local.roles : [
      for policy_arn in lookup(role, "policy_arns", []) : {
        role       = role.name
        policy_arn = policy_arn
      }
    ]
  ])
}

resource "aws_iam_role_policy_attachment" "attachments" {

  for_each = { for r in local.role_policy_association_list : "${r.role}/${r.policy_arn}" => r }

  policy_arn = each.value.policy_arn
  role       = each.value.role

  depends_on = [
    aws_iam_policy.policies,
    aws_iam_role.roles
  ]
}
