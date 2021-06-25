variable "private_key_path" {
  description = "Local path to store private key for SSH"
  type = string
  default = "~/.ssh"
}

variable "name" {
  description = "Name of the SSH keypair to create"
  type = string
  default = "bigbang"
}