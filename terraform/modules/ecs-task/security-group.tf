resource "aws_security_group" "superfluid_sentinel_task" {
  name        = "${var.name}-task-sg"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 443
    to_port         = 443
    security_groups = [var.alb_security_group]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}