output "kms_key_id" {
  value = aws_kms_key.kms
}

output "kms_key_alias" {
  value = aws_kms_alias.kms
}
