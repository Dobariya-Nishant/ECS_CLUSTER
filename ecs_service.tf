resource "aws_ecs_service" "service" {
  count = length(aws_ecs_task_definition.tasks)

  name            = "${var.tasks[count.index].name}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.tasks[count.index].arn
  desired_count   = var.tasks[count.index].desired_count

  network_configuration {
    subnets          = var.tasks[count.index].subnet_ids
    security_groups  = [aws_security_group.task_sg[count.index].id]
    assign_public_ip = false
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  dynamic "load_balancer" {
    for_each = var.tasks[count.index].load_balancer_config != null ? var.tasks[count.index].load_balancer_config : []
    content {
      target_group_arn = load_balancer.value["target_group_arn"]
      container_name   = var.tasks[count.index].name
      container_port   = load_balancer.value["container_port"]
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.tasks[count.index].name}-service"
    }
  )
}