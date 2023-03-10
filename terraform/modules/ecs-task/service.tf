#####################
##   ECS Service   ##
resource "aws_ecs_service" "superfluid_sentinel_service" {
  name            = "${var.name}-svc"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.superfluid_sentinel.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [module.superfluid_sentinel_task_sg.this_security_group_id] # Change to ALB Security group if LB is enabled
    subnets         = data.aws_subnet_ids.superfluid.ids
  }

  # OPTIONAL: If we want a LoadBalancer infrot of ECS image
  #load_balancer {
  #  target_group_arn = var.alb_target_group_arn[0]
  #  container_name   = var.name
  #  container_port   = var.port
  #}
}

data "aws_subnet_ids" "superfluid" {
  vpc_id = var.vpc_id
}
