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

#####################
## Security Groups ##
module "superfluid_sentinel_task" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.16"


  name        = "${var.name}-task-sg"
  description = "Access internet"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}