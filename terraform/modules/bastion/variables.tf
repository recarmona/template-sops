variable "name" {
  description = "The project name to prepend to resources"
  type = string
  default = "bigbang-dev"
}

variable "vpc_id" {
  description = "The VPC where the bastion should be deployed"
  type = string
}

variable "subnet_ids" {
  description = "List of subnet ids where the bastion is allowed"
  type = list(string)
}

variable "ami" {
  description = "The image to use for the bastion"
  type    = string
  default = "ami-017e342d9500ef3b2" # RKE2 RHEL8 STIG (even though we don't need RHEL8, it is hardened)
}

variable "instance_type" {
  description = "The AWS EC2 instance type for the bastion"
  type        = string
  default = "t2.micro"
}

variable "key_name" {
  description = "The key pair name to install on the bastion"
  type        = string
  default = ""
}
variable "tags" {
  description = "The tags to apply to resources"
  type = map(string)
  default = {}
}