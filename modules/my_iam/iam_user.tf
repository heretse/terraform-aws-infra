locals {
  users = yamldecode(file("${var.iam_path}"))["users"]
}

resource "aws_iam_user" "users" {
  # checkov:skip=  CKV_AWS_273: need to do it later

  for_each = { for r in local.users : r.name => r }

  name = each.value.name
  path = "/"

  tags = {
    Department = var.department_name
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Project    = var.project_name
  }
}
