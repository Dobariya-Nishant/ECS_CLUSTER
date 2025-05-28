resource "aws_ecs_capacity_provider" "ec2" {
  count = length(var.auto_scaling_groups)

  name = "${local.ecs_cluster_name}-${count.index}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.auto_scaling_groups[count.index]
    managed_termination_protection = var.enable_managed_termination_protection == true ? "ENABLED" : "DISABLED"
    managed_draining               = var.enable_managed_draining == true ? "ENABLED" : "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 90
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.ecs_cluster_name
    }
  )
}
