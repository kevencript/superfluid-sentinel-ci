resource "aws_vpc" "superfluid-ecs-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}