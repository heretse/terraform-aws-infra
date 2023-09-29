resource "aws_dynamodb_table" "tables" {
  # checkov:skip=CKV_AWS_28: "Ensure Dynamodb point in time recovery (backup) is enabled"
  # checkov:skip=CKV_AWS_119: "Ensure DynamoDB Tables are encrypted using a KMS Customer Managed CMK"
  # checkov:skip=CKV2_AWS_16: "Ensure that Auto Scaling is enabled on your DynamoDB tables"

  for_each = { for r in local.tables : r.name => r }

  dynamic "attribute" {
    for_each = each.value.attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  billing_mode = each.value.billing_mode
  hash_key     = each.value.hash_key
  name         = each.value.name

  point_in_time_recovery {
    enabled = "false"
  }

  range_key      = lookup(each.value, "range_key", null)
  read_capacity  = each.value.read_capacity
  stream_enabled = each.value.stream_enabled ? "true" : "false"
  table_class    = lookup(each.value, "table_class", "STANDARD") == "STANDARD" ? null : each.value.table_class
  write_capacity = each.value.write_capacity
}
