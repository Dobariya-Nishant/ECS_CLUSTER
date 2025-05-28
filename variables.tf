locals {
  pre_fix                      = "${var.resource_name}-${var.environment}" # Prefix used for naming all resources consistently
  ecs_cluster_name             = local.pre_fix                             # ECS cluster name
  ecs_service_role_name        = "${local.pre_fix}-service-role"           # Name for ECS service IAM role
  ecs_task_execution_role_name = "${local.pre_fix}-task-execution-role"    # Name for ECS task execution IAM role
  sg_name                      = "${local.pre_fix}-sg"                     # Security group name

  common_tags = {
    Project     = var.project_name # Project name for tagging
    Environment = var.environment  # Environment name for tagging (e.g., dev, prod)
  }
}

variable "provider_type" {
  type        = string
  description = "Type of ECS launch method to use. Options: 'ec2', 'fargate', 'fargate-spot', or 'combine' for mixed capacity providers."
  validation {
    condition     = contains(["ec2", "fargate", "fargate-spot", "combine"], var.provider_type)
    error_message = "Invalid provider_type. Must be one of: ec2, fargate, fargate-spot, combine."
  }
}

variable "tasks" {
  description = "List of ECS task definitions. Each task defines an ECS service configuration."
  type = list(object({
    name                = string           # Name of the ECS task/service
    image_uri           = string           # Container image URI to run (e.g., ECR or Docker Hub)
    essential           = optional(bool)   # Whether this container is essential to the task
    lb_target_group_arn = optional(string) # ARN of the target group for ALB/NLB, if load balanced
    lb_sg_id            = optional(string) # Security Group ID used for ALB/NLB access
    container_port      = optional(number) # Port exposed by the container (used in ALB target group)
    task_role_arn       = optional(string) # IAM role the task should assume
    cpu                 = optional(number) # CPU units reserved for the container
    memory              = optional(number) # Memory (in MiB) reserved for the container
    enable_public_http  = optional(bool)   # Enable HTTP routing (e.g., via ALB listener rule)
    enable_public_https = optional(bool)   # Enable HTTPS routing (e.g., via ALB + ACM cert)
    subnet_ids          = list(string)     # List of subnet IDs to launch tasks into
    load_balancer_config = optional(list(object({
      sg_id            = string
      target_group_arn = string
      container_port   = number
    })))
    environment = optional(list(object({
      name  = string # Env var name
      value = string # Env var value
    })))             # List of environment variables for the container
    portMappings = optional(list(object({
      containerPort = number # Port exposed by container
      hostPort      = number # Port exposed on host (for EC2 only)
    })))                     # List of container-host port mappings
    desired_count = number   # Number of desired ECS task replicas
  }))
  default = []
}

variable "project_name" {
  type        = string
  description = "Name of the overall project. Used for tagging and logical grouping of resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where ECS services and networking resources will be deployed."
}

variable "enable_managed_draining" {
  type        = bool
  default     = false
  description = "Enable managed draining for ECS capacity providers (recommended for EC2)."
}

variable "enable_managed_termination_protection" {
  type        = bool
  default     = false
  description = "Enable termination protection for EC2-based ECS instances managed by capacity providers."
}

variable "resource_name" {
  type        = string
  description = "Base name used to identify resources (e.g., prefix for ECS cluster, roles, SG, etc.)."
}

variable "environment" {
  type        = string
  description = "Deployment environment name (e.g., dev, staging, prod). Used for naming and tagging."
}

variable "auto_scaling_groups" {
  type        = list(string)
  default     = []
  description = "List of Auto Scaling Group ARNs to be used for EC2-based ECS capacity providers."
}