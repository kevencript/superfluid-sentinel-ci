# VPC variables
variable "vpc_cidr" {
  description = "CIDR range of VPC"
  type        = string
  default     = "10.0.0.0/20"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "superfluid-ecs-vpc"

}

# ECS Variables
variable "name" {
  type        = string
  default     = "superfluid-ecs"
  description = "Name of the application. It will be used to name the resources of this module."

  validation {
    condition     = can(regex("^[a-z\\-]+[a-z]$", var.name))
    error_message = "\"name\" can only contains lower case letter and hyphens."
  }
}

variable "environ" {
  type        = string
  default     = "production"
  description = "Environment of the application. It will be used to name the resources of this module."

  validation {
    condition     = can(regex("^[a-z\\-]+[a-z]$", var.environ))
    error_message = "\"environ\" can only contains lower case letter and hyphens."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "(Optional) Key-value map of resource tags."
}

