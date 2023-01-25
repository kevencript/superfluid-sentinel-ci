output "ecs_cluster_id" {
  value = aws_ecs_cluster.superfluid_ecs_cluster_main.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.superfluid_ecs_cluster_main.name
}

# output "alb_target_group_arn" {
#   value       = module.superfluid_alb[0].target_group_arns
#   description = "Alb Target Group ARN"
# }

# output "alb_security_group" {
#   value       = module.superfluid_alb_security_group[0].this_security_group_id
#   description = "Alb Target Group ARN"
# }
