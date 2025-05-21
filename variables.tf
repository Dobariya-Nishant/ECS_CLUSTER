locals {
  post_fix               = "${var.resource_name}-${var.environment}"
  ecs_cluster_name       = local.post_fix
  capacity_provider_name = local.post_fix

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

variable "provider_type" {
  type        = string
  description = "Choose between: ec2, fargate, fargate-spot, combine"
  validation {
    condition     = contains(["ec2", "fargate", "fargate-spot", "combine"], var.provider_type)
    error_message = "Invalid provider_type. Must be one of: ec2, fargate, fargate-spot, combine."
  }
}

variable "project_name" {
  type        = string
  description = "Name of the overall project. Used for naming and tagging resources."
}

variable "resource_name" {
  type        = string
  description = "Base name used to identify resources (e.g., EC2, SG, etc.)."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)."
}

variable "auto_scaling_groups" {
  type        = list(string)
  description = ""
}

