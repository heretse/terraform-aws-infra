locals {
  kms = yamldecode(file("${var.kms_path}"))["kms"]
}

resource "aws_kms_key" "kms" {
  # checkov:skip=CKV_AWS_227: "Ensure KMS key is enabled"

  for_each = { for r in local.kms : r.tagsName => r }

  customer_master_key_spec = each.value.customer_master_key_spec
  description              = lookup(each.value, "description", "")
  enable_key_rotation      = each.value.enable_key_rotation
  is_enabled               = each.value.is_enabled
  key_usage                = each.value.key_usage
  multi_region             = each.value.multi_region
  policy                   = file("${each.value.policy_file}")

  tags = {
    Name       = each.value.tagsName
    Department = var.department_name
    Env        = var.environment
    Project    = var.project_name
  }

  tags_all = {
    Name       = each.value.tagsName
    Department = var.department_name
    Env        = var.environment
    Project    = var.project_name
  }
}
