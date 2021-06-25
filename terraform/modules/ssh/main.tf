# Creates a SSH key pair that can be used for access to infrastructure
# servers.  The private key is stored on the local computer only in the
# path specified by the variables

# Create SSH key pair
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store private key locally
resource "local_file" "pem" {
  filename        = pathexpand("${var.private_key_path}/${var.name}.pem")
  content         = tls_private_key.ssh.private_key_pem
  file_permission = "0600"
}

#
resource "aws_key_pair" "ssh" {
  key_name   = "${var.name}"
  public_key = tls_private_key.ssh.public_key_openssh
}