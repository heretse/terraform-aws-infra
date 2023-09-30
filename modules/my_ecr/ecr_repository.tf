resource "aws_ecr_repository" "repos" {
  # checkov:skip=CKV_AWS_51: "Ensure ECR Image Tags are immutable"
  # checkov:skip=CKV_AWS_163: "Ensure ECR image scanning on push is enabled"
  # checkov:skip=CKV_AWS_136: "Ensure that ECR repositories are encrypted using KMS"

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
