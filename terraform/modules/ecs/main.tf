locals {
  tags = {
    "app:name"        = random_string.cluster.keepers.name,
    "app:environment" = random_string.cluster.keepers.environ
  }
}

resource "random_string" "cluster" {
  length  = 8
  lower   = false
  special = false

  keepers = {
    name    = var.name,
    environ = var.environ
  }
}

#################
## ECS Cluster ##
resource "aws_ecs_cluster" "superfluid_ecs_cluster_main" {
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
