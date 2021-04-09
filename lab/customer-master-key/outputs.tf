output "key_id" {
  value = aws_kms_key.root.key_id
}

output "key_alias" {
  value = aws_kms_alias.root_alias.name
}
