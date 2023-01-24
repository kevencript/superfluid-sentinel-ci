#############
## Logging ##
module "cloudwatch_kms_key" {
  source = "dod-iac/cloudwatch-kms-key/aws"

  name = format("alias/%s-cloudwatch-logs", var.name)

  tags  = {
    Application = var.name
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name              = format("/aws/ecs/%s", var.name)
  retention_in_days = 1 # expire logs after 1 day
  kms_key_id        = module.cloudwatch_kms_key.aws_kms_key_arn

  tags  = {
    Application = var.name
  }
}
