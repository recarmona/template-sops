# This file creates a new SSH key pair for accessing the bastion and cluster nodes

locals {
  env = yamldecode(file(find_in_parent_folders("env.yaml")))
}

terraform {
  source = "${path_relative_from_include()}//modules/ssh"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name  = local.env.name
}