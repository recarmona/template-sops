output "key_name" {
  description = "The name of the AWS SSH key pair"
  value = aws_key_pair.ssh.key_name
}

output "public_key" {
  description = "The public SSH key"
  value = tls_private_key.ssh.public_key_openssh
}