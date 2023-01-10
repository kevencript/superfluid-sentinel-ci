resource "aws_ecs_task_definition" "superfluid_sentinel" {
  family                   = "${var.name}-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 7548

  execution_role_arn = module.ecs_task_execution_role.arn

  volume {
      name       = "data"
  }

 container_definitions = <<DEFINITION
[
  {
    "image": "docker.io/gabrielobcosta/superfluid-sentinel:0.0.1",
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