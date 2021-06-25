output "vpc_id" {
  description = "The Virtual Private Cloud (VPC) ID"
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "The list of private subnet IDs in the VPC"
  value = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "Thge list of public subnet IDs in the VPC"
  value = module.vpc.public_subnets
}