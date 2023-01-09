resource "aws_ecs_task_definition" "superfluid_sentinel" {
  family                   = "${var.name}-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

 container_definitions = <<DEFINITION
[
  {
    "image": "logicb0x/superfluid-sentinel",
    "cpu": 1024,
    "memory": 2048,
    "name": "superfluid-sentinel",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ]
  }
]
DEFINITION
}