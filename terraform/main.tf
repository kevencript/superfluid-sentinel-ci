module "superfluid_vpc" {
  source         = "./modules/vpc"
  vpc_cidr_block = var.vpc_cidr
  vpc_name       = var.vpc_name
}

module "superfluid_ecs" {
  source             = "./modules/ecs"
  name               = var.name
  environ            = var.environ
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
    }
  ]
  enable_container_insights = true
  vpc_main_route_table_id   = module.superfluid_vpc.vpc_main_route_table_id
  vpc_id                    = module.superfluid_vpc.vpc_id
  vpc_cidr                  = var.vpc_cidr
  tags                      = var.tags
}

module "superfluid_ecs_task" {
  source = "./modules/ecs-task"

  depends_on = [module.superfluid_ecs]

  vpc_id         = module.superfluid_vpc.vpc_id
  name           = var.name
  ecs_cluster_id = module.superfluid_ecs.ecs_cluster_id
  port           = 3000
  app_count      = 1
}