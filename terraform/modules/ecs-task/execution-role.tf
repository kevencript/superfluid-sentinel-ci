####################
## Execution Role ##
module "ecs_task_execution_role" {
  source = "dod-iac/ecs-task-execution-role/aws"

  allow_ecr                  = true
  allow_create_log_groups    = true
  cloudwatch_log_group_names = [aws_cloudwatch_log_group.main.name]

  name = format("app-%s-task-execution-role", var.name)

  tags = {
    Application = var.name
  }
}

###########################
## Secret Manager Policy ##
# resource "aws_iam_role_policy" "secrets_manager_policy_for_ecs" {
#   name = "${var.name}-ecs-secret-manager-policy"
#   role = module.ecs_task_execution_role

#   policy = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "secretsmanager:GetSecretValue"
#             ],
#             "Resource": "arn:aws:secretsmanager:*:*:*"
#         }
#     ]
# }
# EOF
# }

######################
## Grabbing Secrets ##
data "aws_secretsmanager_secret_version" "superfluid_sentinel_secrets" {
  secret_id = "superfluid/sentinel"
}

output "secret_arn" {
  value = data.aws_secretsmanager_secret_version.superfluid_sentinel_secrets.arn
}

# Decode the JSON value stored in the secret
locals {
  sentinel_vars = jsondecode(data.aws_secretsmanager_secret_version.superfluid_sentinel_secrets.secret_string)
}
