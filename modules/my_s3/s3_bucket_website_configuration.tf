resource "aws_s3_bucket_website_configuration" "configurations" {
  
  for_each = { for r in local.s3_buckets : r.bucket => r if lookup(r, "index_document", "") != "" }

  bucket = aws_s3_bucket.s3_bucket[each.value.bucket].id

  index_document {
    suffix = each.value.index_document
  }

  depends_on = [
    aws_s3_bucket.s3_bucket
  ]
}
