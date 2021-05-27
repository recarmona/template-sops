locals {
  env = merge(
    yamldecode(file(find_in_parent_folders("region.yaml"))),
    yamldecode(file(find_in_parent_folders("env.yaml")))
  )
}

terraform {
  source = "${path_relative_from_include()}//modules/pool"
}

include {
  path = find_in_parent_folders()
}

dependency "elb" {
  config_path = "../elb"
  mock_outputs = {
    elb_id = "mock_elb_id"
  }
}

dependency "agent" {
  config_path = "../agent"
  mock_outputs = {
    nodepool_id = "mock_nodepool_id"
  }
}

inputs = {
  elb_id = dependency.elb.outputs.elb_id
  pool_asg_id = dependency.agent.outputs.nodepool_id
  tags = merge(local.env.region_tags, local.env.tags, {})
}