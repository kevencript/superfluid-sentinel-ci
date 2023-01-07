module "superfluid_vpc" {
  source = "./modules/vpc"

  vpc_cidr_block = var.vpc_cidr
  vpc_name       = var.vpc_name
}

module "superfluid_ecs" {
  source = "/modules/ecs"

  name    = var.name
  environ = var.environ

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  capacity_provider_strategies = [
    {
      capacity_provider = "FARGATE"
      weight            = 1
      base              = 1
    },
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 4
      base              = 0
    },
  ]

  enable_container_insights = true
  create_load_balancer      = true

  vpc_id            = var.vpc_id
  public_subnet_ids = var.public_subnet_ids

  tags = var.tags
}