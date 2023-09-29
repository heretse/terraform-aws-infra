resource "aws_ecr_repository" "repos" {

  for_each = { for r in local.repos : r.name => r }

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = lookup(each.value, "scan_on_push", "false")
  }

  image_tag_mutability = lookup(each.value, "image_tag_mutable", true) ? "MUTABLE" : "IMMUTABLE"
  name                 = each.value.name
}
