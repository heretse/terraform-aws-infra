resource "aws_s3_bucket_server_side_encryption_configuration" "configurations" {

  for_each = { for r in local.s3_buckets : r.bucket => r if lookup(r, "server_site_encryption", "") != "" }

  bucket = aws_s3_bucket.s3_bucket[each.value.bucket].id

  rule {    
    bucket_key_enabled = false
    
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  } 

  depends_on = [
    aws_s3_bucket.s3_bucket
  ]
}
