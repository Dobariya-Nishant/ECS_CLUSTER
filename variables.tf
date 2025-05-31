locals {
  pre_fix          = "${var.name}-${var.environment}" // Prefix for naming all resources consistently
  ecs_cluster_name = local.pre_fix                    // ECS cluster name

  common_tags = {
    Project     = var.project_name // Project name tag
    Environment = var.environment  // Environment tag (e.g., dev, prod)
  }
}

variable "provider_type" {
  type        = string
  description = "ECS launch type to use. Options: 'ec2', 'fargate', 'fargate-spot', or 'combine' (for mixed capacity)."
  validation {
    condition     = contains(["ec2", "fargate", "fargate-spot", "combine"], var.provider_type)
    error_message = "Invalid provider_type. Must be one of: ec2, fargate, fargate-spot, combine."
  }
}

variable "tasks" {
  description = "List of ECS task configurations. Each item defines one ECS service."
  type = list(object({
    name                = string                 // ECS service/task name
    image_uri           = string                 // Container image URI (ECR or Docker Hub)
    essential           = optional(bool)         // Whether the container is essential
    lb_target_group_arn = optional(string)       // Target group ARN (for load-balanced services)
    lb_sg_id            = optional(string)       // SG ID used by ALB/NLB
    container_port      = optional(number)       // Port exposed by the container
    task_role_arn       = optional(string)       // IAM role for the task
    cpu                 = optional(number)       // CPU units reserved
    memory              = optional(number)       // Memory in MiB
    enable_public_http  = optional(bool)         // Enable HTTP routing 
    enable_public_https = optional(bool)         // Enable HTTPS routing 
    subnet_ids          = list(string)           // Subnets to launch tasks in
    command             = optional(list(string)) // Custom entrypoint command
    load_balancer_config = optional(list(object({
      sg_id            = string // SG used for load balancer
      target_group_arn = string // Target group ARN
      container_port   = number // Port for container registration
    })))
    environment = optional(list(object({
      name  = string // Environment variable name
      value = string // Environment variable value
    })))
    portMappings = optional(list(object({
      containerPort = number // Port exposed by container
      hostPort      = number // Host port (used only with EC2 launch type)
    })))
    desired_count = number // Number of ECS task replicas
  }))
  default = []
}

variable "project_name" {
  type        = string
  description = "Project name used for tagging and resource grouping."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to deploy ECS tasks and networking resources into."
}

variable "enable_managed_draining" {
  type        = bool
  default     = false
  description = "Enable managed instance draining (recommended for EC2 capacity providers)."
}

variable "enable_managed_termination_protection" {
  type        = bool
  default     = false
  description = "Protect EC2 instances from termination (only for EC2 capacity providers)."
}

variable "enable_managed_scaling" {
  type        = bool
  default     = false
  description = "Enable managed scaling for EC2 Auto Scaling Groups used by ECS."
}

variable "enable_target_tracking_scaling" {
  type        = bool
  default     = false
  description = "Enable target tracking scaling policy for ECS services."
}

variable "name" {
  type        = string
  description = "Base name used to prefix resource names (e.g., ECS cluster, roles, SGs)."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod). Used for naming and tagging."
}

variable "auto_scaling_groups" {
  type        = list(string)
  default     = []
  description = "List of Auto Scaling Group ARNs for EC2 capacity providers."
}
