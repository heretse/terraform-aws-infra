resource "aws_ecr_repository_policy" "repos_policy" {
  for_each = { for r in local.repos : r.name => r if r.permission != "" }

  policy = file("${each.value.permission}")

  repository = each.value.name

  depends_on = [
    aws_ecr_repository.repos
  ]
}
