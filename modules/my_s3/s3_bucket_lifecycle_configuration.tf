resource "aws_s3_bucket_lifecycle_configuration" "configurations" {
  # checkov:skip=CKV_AWS_300: "Ensure S3 lifecycle configuration sets period for aborting failed uploads"

  for_each = { for r in local.s3_buckets : r.bucket => r if length(r.lifecycle_rule) > 0 }

  bucket = aws_s3_bucket.s3_bucket[each.value.bucket].id

  dynamic "rule" {

    for_each = lookup(each.value, "lifecycle_rule", [])

    content {
      id = rule.value.id

      dynamic "abort_incomplete_multipart_upload" {
        for_each = lookup(rule.value, "abort_incomplete_multipart_upload_days", 0) == 0 ? [] : [1]

        content {
          days_after_initiation = rule.value.abort_incomplete_multipart_upload_days
        }
      }

      filter {
        prefix = lookup(rule.value, "prefix", "")
      }

      expiration {
        days                         = lookup(rule.value.expiration, "days", null)
        expired_object_delete_marker = lookup(rule.value.expiration, "expired_object_delete_marker", null)
      }

      status = (lookup(rule.value, "enabled", false)) ? "Enabled" : "Disabled"
    }
  }

  depends_on = [
    aws_s3_bucket.s3_bucket,
    aws_s3_bucket_versioning.versionings
  ]
}
