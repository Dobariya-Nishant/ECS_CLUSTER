resource "aws_ecs_cluster" "cluster" {
  name = local.ecs_cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.ecs_cluster_name
    }
  )
}
