locals {
  user_policy_association_list = flatten([
    for user in local.users : [
      for policy_arn in lookup(user, "policy_arns", []) : {
        user       = user.name
        policy_arn = policy_arn
      }
    ]
  ])
}

resource "aws_iam_user_policy_attachment" "attachments" {
  # checkov:skip=CKV_AWS_40: "Ensure IAM policies are attached only to groups or roles (Reducing access management complexity may in-turn reduce opportunity for a principal to inadvertently receive or retain excessive privileges.)"

  for_each = { for r in local.user_policy_association_list : "${r.user}/${r.policy_arn}" => r }

  policy_arn = each.value.policy_arn
  user       = each.value.user

  depends_on = [
    aws_iam_policy.policies,
    aws_iam_user.users
  ]
}
