data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name = "group-name"
    values = [var.aws_region]
  }
}