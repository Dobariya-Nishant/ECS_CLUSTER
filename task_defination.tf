resource "aws_ecs_task_definition" "tasks" {
  count = length(var.tasks)

  family       = var.tasks[count.index].name
  network_mode = "awsvpc"
  cpu          = var.tasks[count.index].cpu
  memory       = var.tasks[count.index].memory

  execution_role_arn = aws_iam_role.ecs_task_execution_role[0].arn
  task_role_arn      = lookup(var.tasks[count.index], "task_role_arn", null)

  container_definitions = jsonencode([
    {
      name         = var.tasks[count.index].name
      image        = var.tasks[count.index].image_uri
      essential    = var.tasks[count.index].essential
      environment  = lookup(var.tasks[count.index], "environment", [])
      portMappings = var.tasks[count.index].portMappings != null ? var.tasks[count.index].portMappings : []
    }
  ])
}
