locals {
  tags = {
    "app:name"        = random_string.cluster.keepers.name
    "app:environment" = random_string.cluster.keepers.environ
  }
}

resource "random_string" "cluster" {
  length  = 8
  lower   = false
  special = false

  keepers = {
    name    = var.name
    environ = var.environ
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${random_string.cluster.keepers.name}-${random_string.cluster.keepers.environ}-${random_string.cluster.id}"

  capacity_providers = var.capacity_providers

  dynamic "default_capacity_provider_strategy" {
    for_each = var.capacity_provider_strategies

    content {
      capacity_provider = default_capacity_provider_strategy.value["capacity_provider"]
      weight            = default_capacity_provider_strategy.value["weight"]
      base              = default_capacity_provider_strategy.value["base"]
    }
  }

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = merge(var.tags, local.tags)

  lifecycle {
    create_before_destroy = true
  }
}

module "this_alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.16"

  count = var.create_load_balancer ? 1 : 0

  name        = "${var.name}-${var.environ}-alb"
  description = "Access to the public facing Load Balancer"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = merge(var.tags, local.tags)
}

module "this_app_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.16"

  name   = "${var.name}-${var.environ}-app"
  vpc_id = var.vpc_id

  ingress_with_self = [{
    rule = "all-all"
  }]

  computed_ingress_with_source_security_group_id = var.create_load_balancer ? [{
    rule                     = "http-80-tcp"
    source_security_group_id = module.this_alb_security_group[0].this_security_group_id
  }] : []

  number_of_computed_ingress_with_source_security_group_id = var.create_load_balancer ? 1 : 0

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = merge(var.tags, local.tags)
}

# Subnet and Internet Gateway 
resource "aws_subnet" "public" {
  count                   = 2
  cidr_block              = cidrsubnet(aws_vpc.default.cidr_block, 8, 2 + count.index)
  availability_zone       = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id                  = aws_vpc.default.id
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count             = 2
  cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  vpc_id            = aws_vpc.default.id
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.default.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.default.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gateway.id
}

resource "aws_eip" "gateway" {
  count      = 2
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]
}

resource "aws_nat_gateway" "gateway" {
  count         = 2
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gateway.*.id, count.index)
}

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gateway.*.id, count.index)
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

module "this_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.9"

  count = var.create_load_balancer ? 1 : 0

  name = "${substr(random_string.cluster.keepers.name, 0, 12)}-${substr(random_string.cluster.keepers.environ, 0, 12)}-${random_string.cluster.id}"

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = element(aws_subnet.public.*.id, count.index)
  security_groups = [module.this_alb_security_group[0].this_security_group_id]

  target_groups = [{
    target_type      = "ip"
    backend_protocol = "HTTP"
    backend_port     = 80
  }]

  http_tcp_listeners = [{
    port     = 80
    protocol = "HTTP"
  }]

  tags = merge(var.tags, local.tags)
}