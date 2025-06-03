resource "aws_iam_role" "ecs_task_execution_role" {
  count = var.tasks != null ? 1 : 0

  name               = "${local.pre_fix}-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.pre_fix}-task-execution-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "task_execution_policy_attach" {
  count = var.tasks != null ? 1 : 0

  role       = aws_iam_role.ecs_task_execution_role[0].name
  policy_arn = data.aws_iam_policy.ecs_task_execution_role_policy.arn
}
