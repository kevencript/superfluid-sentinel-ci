resource "aws_ecs_task_definition" "task_definition" {
  family                   = "task_definition_name"
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_ecs_service" "example" {
  name            = "example-service"
  cluster         = "existing-cluster"
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1

  launch_type = "FARGATE"
}