output "superfluid_dns" {
  value       = module.superfluid_ecs.this_lb_dns
  description = "DNS name of the AWS ALB (Application Load Balancer)."
}