##########################################
## Grabbing Values from Secret Manager ##
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

