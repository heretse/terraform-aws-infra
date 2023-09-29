resource "aws_ecr_lifecycle_policy" "repos_lifecycle_policy" {
  for_each = { for r in local.repos : r.name => r if r.lifecycle != "" }

  policy = file("${each.value.lifecycle}")

  repository = each.value.name

  depends_on = [
    aws_ecr_repository.repos
  ]
}
