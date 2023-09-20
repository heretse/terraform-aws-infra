data "aws_canonical_user_id" "current_user" {}

resource "aws_s3_bucket" "s3_bucket" {
  for_each = { for r in local.s3_buckets : r.bucket => r }

  bucket = each.value.bucket

  tags = {
    Name       = each.value.bucket
    Department = each.value.department
    Project    = each.value.project
  }

  tags_all = {
    Name       = each.value.bucket
    Department = each.value.department
    Project    = each.value.project
  }
}
