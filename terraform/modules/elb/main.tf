# Creates an Elastic Load Balancer in the VPC/subnet specified
# - Allows ingress traffic on ports 80 and 443 only
# - Supports Istio health checking and SNI in the cluster
# - Maps to node ports in cluster
# - Security group created for other entities to use for ingress from the ELB
# - Attaching a pool to the load balancer is done outside of this Terraform

# Security group for load balancer
resource "aws_security_group" "elb" {
  name_prefix = "${var.name}-elb-"
  description = "${var.name} Elastic Load Balancer"
  vpc_id      = "${var.vpc_id}"

  # Allow all HTTP traffic
  ingress {
    description = "HTTP Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all HTTPS traffic
  ingress {
    description = "HTTPS Traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all egress
  egress {
    description = "All traffic out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# Security group for server pool to allow traffic from load balancer
resource "aws_security_group" "elb_pool" {
  name_prefix = "${var.name}-elb-pool-"
  description = "${var.name} Traffic to Elastic Load Balancer server pool"
  vpc_id      = "${var.vpc_id}"

  # Allow all traffic from load balancer
  ingress {
    description       = "Allow Load Balancer Traffic"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    security_groups = [aws_security_group.elb.id]
  }

  tags = var.tags
}

# Create Elastic Load Balancer
module "elb" {
  source          = "terraform-aws-modules/elb/aws"
  version         = "~> 3.0"
  name = "${var.name}-elb"
  subnets         = var.subnet_ids
  security_groups = [aws_security_group.elb.id]
  internal        = false

  # Port: Description
  # 80: HTTP for applications
  # 443: HTTPS for applications
  # 15021: Istio Health Checks
  # 15443: Istio SNI Routing in multi-cluster environment
  listener = [
    {
      instance_port     = var.node_port_http
      instance_protocol = "TCP"
      lb_port           = 80
      lb_protocol       = "tcp"
    },
    {
      instance_port     = var.node_port_https
      instance_protocol = "TCP"
      lb_port           = 443
      lb_protocol       = "tcp"
    },
    {
      instance_port     = var.node_port_health_checks
      instance_protocol = "TCP"
      lb_port           = 15021
      lb_protocol       = "tcp"
    },
    {
      instance_port     = var.node_port_sni
      instance_protocol = "TCP"
      lb_port           = 15443
      lb_protocol       = "tcp"
    },
  ]

  health_check = {
    target              = "TCP:${var.node_port_health_checks}"
    interval            = 10
    healthy_threshold   = 2
    unhealthy_threshold = 6
    timeout             = 5
  }

  access_logs = {}

  tags = merge({
    "kubernetes.io/cluster/${var.name}" = "shared"
  }, var.tags)
}