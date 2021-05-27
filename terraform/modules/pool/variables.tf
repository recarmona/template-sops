variable "elb_id" {
  description = "The load balancer ID to attach the pool"
  type = string
}

variable "pool_asg_id" {
  description = "The autoscale group IDs that make up the pool to attach to the load balancer"
  type = string
}