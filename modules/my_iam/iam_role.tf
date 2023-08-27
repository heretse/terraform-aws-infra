locals {
  roles = yamldecode(file("${var.iam_path}"))["roles"]
}

resource "aws_iam_role" "roles" {

  for_each = { for r in local.roles : r.name => r }

  assume_role_policy = each.value.assume_role_policy_json_file != "" ? file("${each.value.assume_role_policy_json_file}") : <<POLICY
  {}
  POLICY

  description          = each.value.description
  max_session_duration = "3600"
  name                 = each.value.name
  path                 = each.value.path

  tags = {
    Department = var.department_name
    Name       = each.value.tag_name
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = each.value.tag_name
    Project    = var.project_name
  }
}
