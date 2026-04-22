########################################
# Create IAM Role (only if enabled)
########################################
resource "aws_iam_role" "ecs_task_execution_role" {
  count = var.create_iam_role ? 1 : 0

  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

########################################
# Use Existing IAM Role
########################################
data "aws_iam_role" "existing" {
  count = var.create_iam_role ? 0 : 1
  name  = var.iam_role_name
}

########################################
# Attach Policy (works for both)
########################################
resource "aws_iam_role_policy_attachment" "ecs_policy" {
  role = var.create_iam_role ? aws_iam_role.ecs_task_execution_role[0].name : data.aws_iam_role.existing[0].name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
