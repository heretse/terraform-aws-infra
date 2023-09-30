data "aws_canonical_user_id" "current_user" {}

resource "aws_s3_bucket" "s3_bucket" {
  # checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  # checkov:skip=CKV2_AWS_6: "Ensure that S3 bucket has a Public Access block"
  # checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled"
  # checkov:skip=CKV_AWS_21: "Ensure all data stored in the S3 bucket have versioning enabled"
  # checkov:skip=CKV_AWS_145: "Ensure that S3 buckets are encrypted with KMS by default"
  # checkov:skip=CKV2_AWS_62: "Ensure S3 buckets should have event notifications enabled"

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
