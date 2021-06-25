output "accesskey" {
  value = aws_iam_access_key.this.id
}

output "secretkey" {
  value = aws_iam_access_key.this.secret
}