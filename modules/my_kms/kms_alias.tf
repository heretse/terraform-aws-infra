resource "aws_kms_alias" "kms" {
  for_each = { for r in local.kms : r.tagsName => r }
  
  name = each.value.alias_name
  target_key_id = aws_kms_key.kms[each.value.tagsName].id
}
