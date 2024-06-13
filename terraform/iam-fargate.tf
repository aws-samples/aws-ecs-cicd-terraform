
# ---------------------------------------------------------------------------------------------------------------------
# ECS TASK EXECUTION ROLE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "tasks-execution-role" {
  name               = "${var.fargate-task-service-role}ECSTasksExecutionRole" 
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.tasks-service-assume-policy.json
}

data "aws_iam_policy_document" "tasks-execution-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "tasks-execution-role-attachment" {
  role       = aws_iam_role.tasks-execution-role.name
  policy_arn = data.aws_iam_policy.AmazonECSTaskExecutionRolePolicy.arn
}

# ---------------------------------------------------------------------------------------------------------------------
# ECS TASK ROLE
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_role" "tasks-service-role" {
  name               = "${var.fargate-task-service-role}ECSTasksServiceRole" 
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.tasks-service-assume-policy.json
}

data "aws_iam_policy_document" "tasks-service-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}