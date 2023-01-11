######################
## Task Definiition ##
resource "aws_ecs_task_definition" "superfluid_sentinel" {
  family                   = "${var.name}-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 1024

  execution_role_arn = module.ecs_task_execution_role.arn

  volume {
    name = "data"
  }

 container_definitions = <<DEFINITION
[
  {
    "image": "public.ecr.aws/i0x4j1n5/superfluid-sentinel:latest",
    "cpu": 1024,
    "memory": 1024,
    "name": "superfluid-sentinel",
    "networkMode": "awsvpc",
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
          "awslogs-group": "/aws/ecs/superfluid-sentinel",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "superfluid-sentinel"
      }
    },
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
        "containerPath": "/data",
        "readOnly": false
      }
    ]
  }
]
DEFINITION
}