resource "aws_ecs_capacity_provider" "providers" {
  count = length(var.aws_autoscaling_groups)

  name = "${local.capacity_provider_name}-${count.index}"

  auto_scaling_group_provider {
    auto_scaling_group_arn   = var.aws_autoscaling_groups[count.index].arn
    managed_termination_protection = "ENABLED"
    managed_draining = "ENABLED"

    managed_scaling {
      maximum_scaling_step_size = 10
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 80
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.ecs_cluster_name
    }
  )
}