#####################
## Security Groups ##
module "superfluid_sentinel_task_sg" {
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