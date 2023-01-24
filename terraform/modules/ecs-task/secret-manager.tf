##########################################
## Grabbing Values from Secret Manager ##
data "aws_secretsmanager_secret_version" "superfluid_sentinel_secrets" {
  secret_id = "superfluid/sentinel"
}

output "secret_arn" {
  value = data.aws_secretsmanager_secret_version.superfluid_sentinel_secrets.arn
}

