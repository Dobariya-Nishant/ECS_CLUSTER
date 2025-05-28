resource "aws_ecs_task_definition" "tasks" {
  count = length(var.tasks)

  family       = var.tasks[count.index].name
  cpu          = var.tasks[count.index].cpu
  memory       = var.tasks[count.index].memory
  network_mode = "awsvpc"

  execution_role_arn = aws_iam_role.ecs_task_execution_role[0].arn
  task_role_arn      = lookup(var.tasks[count.index], "task_role_arn", null)

  container_definitions = jsonencode([
    {
      name         = var.tasks[count.index].name
      image        = var.tasks[count.index].image_uri
      essential    = var.tasks[count.index].essential
      environment  = lookup(var.tasks[count.index], "environment", [])
      portMappings = lookup(var.tasks[count.index], "portMappings", [])
    }
  ])
}
