variable "name" {}

variable "bucket_force_destroy" {
  type = bool
  default = true
}

variable "tags" {
  type = map(string)
  default = {}
}