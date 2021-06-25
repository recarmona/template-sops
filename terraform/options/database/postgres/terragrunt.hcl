locals {
  env = merge(
    yamldecode(file(find_in_parent_folders("region.yaml"))),
    yamldecode(file(find_in_parent_folders("env.yaml")))
  )
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-rds-aurora.git?ref=v3.5.0"
}

include {
  path = find_in_parent_folders()
}

dependency "server" {
  config_path = "../server"
  mock_outputs = {
    cluster_sg = "mock_cluster_sg"
  }
}

inputs = {
  name               = "${local.env.locals.name}-postgres"

  vpc_id             = local.env.locals.vpc_id
  subnets            = local.env.locals.subnets

  engine = "aurora-postgresql"
  engine_version = "12.4"

  replica_count = 1

  allowed_security_groups         = [dependency.server.outputs.cluster_sg]
//  allowed_cidr_blocks             = ["10.20.0.0/20"]
  instance_type                   = "db.t3.medium"
  storage_encrypted               = true
  apply_immediately               = true

  username = "bigbang"
  skip_final_snapshot = true
  ca_cert_identifier = "rds-ca-2017"

  tags = merge({}, local.env.locals.tags)
}
