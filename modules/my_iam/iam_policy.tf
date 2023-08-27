locals {
  policies = yamldecode(file("${var.iam_path}"))["policies"]
}

resource "aws_iam_policy" "policies" {

  for_each = { for r in local.policies : r.name => r }

  description = each.value.description
  name        = each.value.name
  path        = each.value.path

  policy = file("${each.value.json_file}")

  tags = {
    Department = var.department_name
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Project    = var.project_name
  }
}
