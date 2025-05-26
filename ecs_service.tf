resource "aws_ecs_service" "service" {
  name            = "mongodb"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.mongo.arn
  desired_count   = 2
  iam_role        = aws_iam_role.ecs_service_role.arn
  depends_on = [
    aws_iam_role_policy_attachment.ecs_policy_attach
  ]

  dynamic "capacity_provider_strategy" {
    for_each = contains(["ec2", "combine"], var.provider_type) ? [1] : []
    content {
      capacity_provider = "EC2"
      weight            = 3
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = contains(["fargate-spot", "combine"], var.provider_type) ? [1] : []
    content {
      capacity_provider = "FARGATE_SPOT"
      weight            = 2
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = contains(["fargate", "combine"], var.provider_type) ? [1] : []
    content {
      capacity_provider = "FARGATE"
      weight            = 1
    }
  }

  network_configuration {
    subnets          = local.subnet_ids
    security_groups  = [aws_security_group.sg.id]
    assign_public_ip = false
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  dynamic "load_balancer" {
    for_each = var.aws_lb_target_group_arn != null ? [1] : []
    content {
      target_group_arn = var.aws_lb_target_group_arn
      container_name   = "mongo"
      container_port   = 8080
    }
  }
}