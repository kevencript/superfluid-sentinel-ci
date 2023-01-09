variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "name" {
  type        = string
  description = "App name"
}

variable "ecs_cluster_id" {
  type        = string
  description = "Cluster ID"
}

variable "alb_security_group" {
  type        = string
  description = "ALB security group"
}

variable "alb_target_group_arn" {
  type        = list
  description = "ALB Target group ARN"
}

variable "port" {
  type        = string
  description = "Port"
  default     = 0
}

variable "app_count" {
  type        = string
  description = "Port"
  default     = 2
}
