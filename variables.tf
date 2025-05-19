locals {
  post_fix                    = "${var.resource_name}-${var.environment}"
  ecs_cluster_name = "${local.post_fix}"
  capacity_provider_name = "${local.post_fix}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
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

variable "aws_autoscaling_groups" {
  type        = list(string)
  description = ""
}

variable "loadbalancer_sg_id" {
  type        = string
  default     = null
  description = "Security group ID for the load balancer. Required when public access is disabled or no public subnets are defined."
  validation {
    condition = (
      !(var.enable_public_access == false) || (var.loadbalancer_sg_id != null)
    )
    error_message = "When public access is disabled or no public subnets are defined, 'loadbalancer_sg_id' must be provided."
  }
}




