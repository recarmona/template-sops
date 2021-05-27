output "alias" {
  value = aws_kms_alias.this.name
}

output "id" {
  value = aws_kms_key.this.key_id
}

output "arn" {
  value = aws_kms_key.this.arn
}