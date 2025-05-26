resource "aws_iam_role" "ecs_service_role" {
  name               = local.ecs_service_role_name
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attach" {

  role       = aws_iam_role.ecs_service_role.name
  policy_arn = data.aws_iam_policy.ecs_service_role_policy.arn
}
