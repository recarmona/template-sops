locals {
  env = merge(
    yamldecode(file(find_in_parent_folders("region.yaml"))),
    yamldecode(file(find_in_parent_folders("env.yaml")))
  )
}

terraform {
  source = "${path_relative_from_include()}//modules/elb"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
  mock_outputs = {
    vpc_id = "mock_vpc_id"
    public_subnet_ids = ["mock_priv_subnet1", "mock_priv_subnet2", "mock_priv_subnet3"]
  }
}

inputs = {
  name  = local.env.name
  vpc_id = dependency.vpc.outputs.vpc_id
  subnet_ids = dependency.vpc.outputs.public_subnet_ids
  tags = merge(local.env.region_tags, local.env.tags, {})
}