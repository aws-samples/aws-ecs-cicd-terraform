# ---------------------------------------------------------------------------------------------------------------------
# Code Commit
# ---------------------------------------------------------------------------------------------------------------------

# Code Commit repo
resource "aws_codecommit_repository" "source_repo" {
  repository_name = var.source_repo_name
  description = "Application Git Repository"
  tags = {
    Name = "${var.stack}-Git-Repo"
    Project = var.project
  }
}

# Trigger role and event rule to trigger pipeline
resource "aws_iam_role" "trigger_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  path = "/"
  tags = {
    Project = var.project
  }
}

resource "aws_iam_policy" "trigger_policy" {
  description = "Policy to allow rule to invoke pipeline"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "codepipeline:StartPipelineExecution"
      ],
      "Effect": "Allow",
      "Resource": "${aws_codepipeline.pipeline.arn}"
    }
  ]
}
EOF
  tags = {
    Project = var.project
  }
}

resource "aws_iam_role_policy_attachment" "trigger-attach" {
  role = aws_iam_role.trigger_role.name
  policy_arn = aws_iam_policy.trigger_policy.arn
}

resource "aws_cloudwatch_event_rule" "trigger_rule" {
  description = "Trigger the pipeline on change to repo/branch"
  event_pattern = <<PATTERN
{
  "source": [ "aws.codecommit" ],
  "detail-type": [ "CodeCommit Repository State Change" ],
  "resources": [ "${aws_codecommit_repository.source_repo.arn}" ],
  "detail": {
    "event": [ "referenceCreated", "referenceUpdated" ],
    "referenceType": [ "branch" ],
    "referenceName": [ "${var.source_repo_branch}" ]
  }
}
PATTERN
  role_arn = aws_iam_role.trigger_role.arn
  is_enabled = true
  tags = {
    Project = var.project
  }

}

resource "aws_cloudwatch_event_target" "target_pipeline" {
  rule = aws_cloudwatch_event_rule.trigger_rule.name
  arn = aws_codepipeline.pipeline.arn
  role_arn = aws_iam_role.trigger_role.arn
  target_id = "${var.source_repo_name}-${var.source_repo_branch}-pipeline"
}

# Outputs
output "source_repo_clone_url_http" {
  value = aws_codecommit_repository.source_repo.clone_url_http
}
