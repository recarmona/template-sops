# This file sets up a bastion server (aka jump box) in AWS to access the RKE2 cluster from the internet through SSH

locals {
  env = merge(
    yamldecode(file(find_in_parent_folders("region.yaml"))),
    yamldecode(file(find_in_parent_folders("env.yaml")))
  )
}

terraform {
  source = "${path_relative_from_include()}//modules/bastion"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "mock_vpc_id"
    public_subnet_ids = ["mock_pub_subnet1", "mock_pub_subnet2", "mock_pub_subnet3"]
  }
}

dependency "ssh" {
  config_path = "../ssh"
  mock_outputs = {
    public_key = "mock_public_key"
    key_name = "mock_key_name"
  }
}

inputs = {
  name  = local.env.name
  vpc_id = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.public_subnet_ids
  ami = local.env.bastion.image
  instance_type = local.env.bastion.type
  key_name = dependency.ssh.outputs.key_name
  tags = merge(local.env.region_tags, local.env.tags, {})
}