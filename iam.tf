resource "aws_iam_role" "aws-dev-datadog-role" {
  name = "aws-dev-datadog-role"
  assume_role_policy = data.aws_iam_policy_document.aws-dev-datadog-policy-document-assume.json
}

resource "aws_iam_policy" "aws-dev-datadog-policy" {
  name = "aws-dev-datadog-policy"
  policy = data.aws_iam_policy_document.aws-dev-datadog-policy-document-json.json
}

resource "aws_iam_role_policy_attachment" "aws-dev-datadog-role-attachment" {
  role = aws_iam_role.aws-dev-datadog-role.name
  policy_arn = aws_iam_policy.aws-dev-datadog-policy.arn
}

data "aws_iam_policy_document" "aws-dev-datadog-policy-document-json" {
  statement {
    sid = "AllowDatadogToReadECSMetrics"
    effect = "Allow"
    actions = [
      "ecs:RegisterContainerInstance",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Submit*",
      "ecs:Poll",
      "ecs:StartTask",
      "ecs:StartTelemetrySession"
    ]
    resources = [ "*" ]
  }
}

data "aws_iam_policy_document" "aws-dev-datadog-policy-document-assume" {
  statement {
    effect = "Allow"
    actions = [ "sts:AssumeRole" ]
    principals {
      type = "Service"
      identifiers = [ "ecs-tasks.amazonaws.com" ]
    }
  }
}

