resource "aws_ecs_task_definition" "superfluid_sentinel" {
  family                   = "${var.name}-sentinel"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 1024
  memory                   = 2048

 container_definitions = <<DEFINITION
[
  {
    "image": "${container_image}",
    "cpu": 1024,
    "memory": 2048,
    "name": "${var.name}-sentinel",
    "networkMode": "awsvpc",
    "portMappings": [
      {
        "containerPort": ${var.port},
        "hostPort": ${var.port}
      }
    ]
  }
]
DEFINITION
}