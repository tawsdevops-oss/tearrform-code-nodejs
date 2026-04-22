locals {
  execution_role_arn = var.create_iam_role ? aws_iam_role.ecs_task_execution_role[0].arn : data.aws_iam_role.existing[0].arn
}
