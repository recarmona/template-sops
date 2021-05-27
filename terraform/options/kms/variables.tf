variable "name" {}

variable "principal_grants" {
  type = list(string)
  description = "principals to grant Decrypt to"
  default = []
}

variable "tags" {
  type = map(string)
  default = {}
}