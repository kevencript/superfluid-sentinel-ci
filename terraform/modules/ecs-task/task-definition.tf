resource "aws_ecs_task_definition" "superfluid_sentinel" {
  family                   = "${var.name}-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

  volume {
      name       = "superfluid-data"
      host_path   = "/ecs/superfluid-data-storage"
  }

 container_definitions = <<DEFINITION
[
  {
    "image": "docker.io/gabrielobcosta/superfluid-sentinel-sentinel:0.0.1",
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
        "sourceVolume": "superfluid-data",
        "containerPath": "/app/data",
        "readOnly": false
      }
    ]
  }
]
DEFINITION
}