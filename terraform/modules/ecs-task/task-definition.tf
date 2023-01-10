resource "aws_ecs_task_definition" "superfluid_sentinel" {
  family                   = "${var.name}-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  execution_role_arn = module.ecs_task_execution_role.arn

  log_configuration {
    log_driver = "awslogs"
    options = {
      "awslogs-group" = "${var.name}-log-group"
      "awslogs-region" = "us-east-1"
      "awslogs-stream-prefix" = "${var.name}-log-group"
    }
  }

  volume {
      name       = "data"
  }

 container_definitions = <<DEFINITION
[
  {
    "image": "public.ecr.aws/i0x4j1n5/superfluid-sentinel:latest",
    "cpu": 1024,
    "memory": 2048,
    "name": "superfluid-sentinel",
    "networkMode": "awsvpc",
    "essential": true,
    "environment": [
      {
        "name": "NODE_ENV",
        "value": "production"
      },
      {
        "name": "DB_PATH",
        "value": "data/db.sqlite"
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "data",
        "containerPath": "/app/data",
        "readOnly": false
      }
    ]
  }
]
DEFINITION
}