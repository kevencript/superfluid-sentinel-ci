output "ecs_cluster_name" {
  value       = aws_ecs_cluster.superfluid_ecs_cluster.name
  description = "Name of the ECS cluster."
}

output "superfluid_security_group_id" {
  value       = module.superfluid_security_group.this_security_group_id
  description = "ID of the application Security Group."
}

output "this_lb_arn" {
  value       = var.create_load_balancer ? module.superfluid_alb[0].this_lb_arn : null
  description = "ARN of the AWS ALB (Application Load Balancer)."
}

output "this_lb_dns" {
  value       = var.create_load_balancer ? module.superfluid_alb[0].this_lb_dns_name : null
  description = "DNS name of the AWS ALB (Application Load Balancer)."
}

