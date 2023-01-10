module "ecs_task_execution_role" {
  source = "dod-iac/ecs-task-execution-role/aws"

  allow_ecr = true
  allow_create_log_groups    = true
  cloudwatch_log_group_names = ["*"]
  name = format("app-%s-task-execution-role", var.name)

  tags  = {
    Application = var.name
  }
}