# Connects an Elastic Load Balancer to a pool of servers

resource "aws_autoscaling_attachment" "pool" {
  elb                    = var.elb_id
  autoscaling_group_name = var.pool_asg_id
}
