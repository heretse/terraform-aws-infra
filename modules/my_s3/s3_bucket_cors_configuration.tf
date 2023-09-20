resource "aws_s3_bucket_cors_configuration" "configurations" {

  for_each = { for r in local.s3_buckets : r.bucket => r if lookup(r, "cors_rule", "") != "" }
  
  bucket = aws_s3_bucket.s3_bucket[each.value.bucket].id

  cors_rule {
    allowed_headers = each.value.cors_rule.allowed_headers == "" ? null : each.value.cors_rule.allowed_headers
    allowed_methods = each.value.cors_rule.allowed_methods == "" ? null : each.value.cors_rule.allowed_methods
    allowed_origins = each.value.cors_rule.allowed_origins == "" ? null : each.value.cors_rule.allowed_origins
    expose_headers  = each.value.cors_rule.expose_headers == "" ? null : each.value.cors_rule.expose_headers
    max_age_seconds = each.value.cors_rule.max_age_seconds
  }

  depends_on = [
    aws_s3_bucket.s3_bucket
  ]
}
