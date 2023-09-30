resource "aws_kinesis_stream" "streams" {
  # checkov:skip=CKV_AWS_43: "Ensure Kinesis Stream is securely encrypted"

  for_each = { for r in local.streams : r.name => r }

  encryption_type           = each.value.encryption_type
  kms_key_id                = lookup(each.value, "kms_key_id", null)
  name                      = each.value.name
  retention_period          = each.value.retention_period
  shard_count               = each.value.shard_count
  enforce_consumer_deletion = lookup(each.value, "enforce_consumer_deletion", null)
}
