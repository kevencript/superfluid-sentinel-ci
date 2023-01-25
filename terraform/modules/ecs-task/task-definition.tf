######################
## Task Definiition ##
resource "aws_ecs_task_definition" "superfluid_sentinel" {
  family                   = "${var.name}-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 128
  memory                   = 512

  execution_role_arn = module.ecs_task_execution_role.arn

  volume {
    name = "data"
  }

  container_definitions = <<DEFINITION
[
  {
    "image": "public.ecr.aws/i0x4j1n5/superfluid-sentinel:latest",
    "cpu": 128,
    "memory": 512,
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
        "value": "${local.sentinel_vars.NODE_ENV}"
      },
      {
        "name": "DB_PATH",
        "value": "${local.sentinel_vars.DB_PATH}"
      },
      {
        "name": "HTTP_RPC_NODE",
        "value": "${local.sentinel_vars.HTTP_RPC_NODE}"
      },
      {
        "name": "PRIVATE_KEY",
        "value": "${local.sentinel_vars.PRIVATE_KEY}"
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
