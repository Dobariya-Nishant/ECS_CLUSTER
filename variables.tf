locals {
  pre_fix               = "${var.resource_name}-${var.environment}"
  ecs_cluster_name      = local.pre_fix
  ecs_service_role_name = "${local.pre_fix}-service-role"
  sg_name = "${local.pre_fix}-sg"
  subnet_ids            = concat(var.public_subnet_ids, var.private_subnet_ids)

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

variable "enable_managed_draining" {
  type    = bool
  default = false
}

variable "enable_managed_termination_protection" {
  type    = bool
  default = false
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

variable "private_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of private subnet IDs for launching EC2 instances without public access."
}

variable "public_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of public subnet IDs used when public access is enabled."
}
variable "aws_lb_target_group_arn" {
  type        = string
  default     = null
  description = "List of public subnet IDs used when public access is enabled."
}

variable "enable_public_access" {
  type        = bool
  default     = false
  description = "List of public subnet IDs used when public access is enabled."
}

variable "enable_http" {
  type        = bool
  default     = false
  description = "List of public subnet IDs used when public access is enabled."
}

variable "enable_https" {
  type        = bool
  default     = false
  description = "List of public subnet IDs used when public access is enabled."
}

variable "enable_ssh" {
  type        = bool
  default     = false
  description = "List of public subnet IDs used when public access is enabled."
}

variable "loadbalancer_sg_id" {
  type        = string
  default     = null
  description = "List of public subnet IDs used when public access is enabled."
}




