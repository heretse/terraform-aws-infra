resource "aws_s3_bucket_versioning" "versionings" {
  
  for_each = { for r in local.s3_buckets : r.bucket => r }

  bucket = aws_s3_bucket.s3_bucket[each.value.bucket].id

  versioning_configuration {
    status = each.value.versioning
  }

  depends_on = [
    aws_s3_bucket.s3_bucket
  ]
}
