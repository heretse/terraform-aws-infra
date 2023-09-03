locals {
  instance_profiles = yamldecode(file("${var.iam_path}"))["instance_profiles"]
}

resource "aws_iam_instance_profile" "instance_profile" {

  for_each = { for r in local.instance_profiles : r.name => r }

  name = each.value.name
  role = each.value.role

  tags = {
    Department = var.department_name
    Name       = each.value.name
    Project    = var.project_name
  }

  tags_all = {
    Department = var.department_name
    Name       = each.value.name
    Project    = var.project_name
  }
}
