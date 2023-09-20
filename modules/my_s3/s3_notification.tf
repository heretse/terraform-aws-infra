resource "aws_s3_bucket_notification" "bucket_notifications" {
  for_each = { for r in local.s3_buckets : r.bucket => r if lookup(r, "notification_eventbridge", false) == true }

  bucket = aws_s3_bucket.s3_bucket["${each.value.bucket}"].id

  eventbridge = true
}
