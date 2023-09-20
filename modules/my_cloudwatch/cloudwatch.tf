locals {
  cloudwatch_loggroups = yamldecode(file("${var.cloudwatch_path}"))["loggroups"]
}


resource "aws_cloudwatch_log_group" "log_group" {
  for_each = { for r in local.cloudwatch_loggroups : r.loggroup_name => r }


  name = each.value.loggroup_name
  retention_in_days = each.value.retention_in_days

  tags = {
    Name       = each.value.loggroup_name
    Department = var.department_name
    Project    = var.project_name
  }

  tags_all = {
    Name       = each.value.loggroup_name
    Department = var.department_name
    Project    = var.project_name
  }
}
