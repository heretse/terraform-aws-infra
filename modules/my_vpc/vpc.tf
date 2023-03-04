provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

resource "aws_vpc" "my_vpc" {
  # checkov:skip=CKV2_AWS_11: we only enable flow log on specific vpc
  # checkov:skip=CKV2_AWS_12: we will watch it
  for_each = { for r in local.vpcs : r.vpc_name => r }

  assign_generated_ipv6_cidr_block = lookup(each.value, "assign_generated_ipv6_cidr_block", false)
  cidr_block                       = each.value.vpc_cidr
  enable_dns_hostnames             = true
  enable_dns_support               = true
  instance_tenancy                 = "default"

  tags = {
    Department = var.department_name
    Name       = each.value.vpc_name
    Project    = lookup(each.value, "project", var.project_name)
  }

  tags_all = {
    Department = var.department_name
    Name       = each.value.vpc_name
    Project    = var.project_name
  }
}
