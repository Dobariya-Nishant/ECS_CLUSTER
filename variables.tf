locals {
  pre_fix                      = "${var.resource_name}-${var.environment}"
  ecs_cluster_name             = local.pre_fix
  ecs_service_role_name        = "${local.pre_fix}-service-role"
  ecs_task_execution_role_name = "${local.pre_fix}-task-execution-role"
  sg_name                      = "${local.pre_fix}-sg"

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

variable "tasks" {
  type = list(object({
    name                 = string
    image_uri            = string
    essential            = optional(bool)
    lb_target_group_arn  = optional(string)
    lb_sg_id             = optional(string)
    container_port       = optional(number)
    task_role_arn        = optional(string)
    cpu                  = optional(number)
    memory               = optional(number)
    enable_http          = optional(bool)
    enable_https         = optional(bool)
    enable_public_access = optional(bool)
    subnet_ids           = list(string)
    environment = optional(list(object({
      name  = string
      value = string
    })))
    portMappings = optional(list(object({
      containerPort = number
      hostPort      = number
    })))
    desired_count = number
  }))
  default     = []
  description = "List of ECS task definitions"
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




