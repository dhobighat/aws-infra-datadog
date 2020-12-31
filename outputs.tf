output "ecs-task-definition-arn" {
  value = aws_ecs_task_definition.datadog-agent-task-definition.arn
}