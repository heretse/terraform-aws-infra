locals {
  groups = yamldecode(file("${var.iam_path}"))["groups"]
}

resource "aws_iam_group" "groups" {

  for_each = { for r in local.groups : r.name => r }

  name = each.value.name
  path = "/"
}
