#############
## Logging ##
module "cloudwatch_kms_key" {
  source = "dod-iac/cloudwatch-kms-key/aws"

  name = format("alias/%s-cloudwatch-logs", var.name)

  tags = {
    Application = var.name
  }
}

resource "aws_cloudwatch_log_group" "main" {
  name              = format("/aws/ecs/%s", var.name)
  retention_in_days = 1 # expire logs after 1 day
  kms_key_id        = module.cloudwatch_kms_key.aws_kms_key_arn

  tags = {
    Application = var.name
  }
}

###################
## Notifications ##
resource "aws_sns_topic" "superfluid_principal" {
  name = "${var.name}-notification"
  tags = {
    ClusterName = var.ecs_cluster_name
  }
}

resource "aws_sns_topic_subscription" "superfluid_principal_email" {
  topic_arn = aws_sns_topic.superfluid_principal.arn
  protocol  = "email"
  endpoint  = var.cloudwatch_notification_email
}

#############
## Alarms  ##
resource "aws_cloudwatch_metric_alarm" "ecs_task_running" {
  alarm_name          = "${var.name}-ecs-task-running-alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  threshold           = 1
  alarm_description   = "Superfluid ECS CloudWatch Alarm to have sure that we have at minimum 1 Running task into the cluster"
  alarm_actions       = [aws_sns_topic.superfluid_principal.arn]

  metric_query {
    id          = "e1"
    expression  = "IF(m1 < m2)"
    label       = "DesiredCountNotMet"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "RunningTaskCount"
      namespace   = "ECS/ContainerInsights"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ServiceName = aws_ecs_service.superfluid_sentinel_service.name
        ClusterName = var.ecs_cluster_name
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "DesiredTaskCount"
      namespace   = "ECS/ContainerInsights"
      period      = "60"
      stat        = "Sum"
      unit        = "Count"

      dimensions = {
        ServiceName = aws_ecs_service.superfluid_sentinel_service.name
        ClusterName = var.ecs_cluster_name
      }
    }
  }
}


