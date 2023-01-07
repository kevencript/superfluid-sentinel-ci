resource "aws_vpc" "superfluid_ecs_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = var.vpc_name
  }
}

output "vpc_id" {
  value = aws_vpc.superfluid_ecs_vpc.id
}

output "vpc_main_route_table_id" {
  value = aws_vpc.superfluid_ecs_vpc.main_route_table_id
}

