resource "aws_ecs_service" "hello_world" {
  name            = "${var.name}-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.superfluid_sentinel.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups = [aws_security_group.superfluid_sentinel_task.id]
    subnets         = var.private_subnet_ids
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "${var.name}-sentinel"
    container_port   = var.port
  }

  depends_on = [module.superfluid_ecs]
}