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
