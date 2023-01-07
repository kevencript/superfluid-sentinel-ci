# VPC variables
variable "vpc_cidr" {
  description = "CIDR range of VPC"
  type        = string
  default     = "10.0.0.0/20"
}

# VPC variables
variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "superfluid-ecs-vpc"

}