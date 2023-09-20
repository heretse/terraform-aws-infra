resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  for_each = { for r in local.s3_buckets : r.bucket => r if r.bucket_policy_file != "" }

  bucket = each.value.bucket
  policy = file("${each.value.bucket_policy_file}")

  depends_on = [
    aws_s3_bucket.s3_bucket
  ]
}
