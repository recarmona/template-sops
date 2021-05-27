output "elb_id" {
  description = "The Elastic Load Balancer (ELB) ID"
  value = module.elb.elb_id
}

output "pool_sg_id" {
  description = "The ID of the security group used as an inbound rule for load balancer's back-end application instances"
  value = aws_security_group.elb_pool.id
}