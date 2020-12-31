resource "aws_ecs_service" "datadog-agent-service" {
  name            = "datadog-agent-service"
  cluster         = var.ecs-cluster-id
  task_definition = aws_ecs_task_definition.datadog-agent-task-definition.arn

  # This allows running once for every instance
  scheduling_strategy = "DAEMON"
}

resource "aws_ecs_task_definition" "datadog-agent-task-definition" {
  family        = "datadog-agent-service"
  task_role_arn = aws_iam_role.aws-dev-datadog-role.arn

  container_definitions = <<EOF
[
  {
    "name": "datadog-agent",
    "image": "datadog/agent:latest",
    "cpu": 10,
    "memory": 256,
    "environment": [{
      "name" : "DD_API_KEY",
      "value" : "${var.datadog-api-key}"
    }],
    "command": [
      "bash",
      "-c",
      "${var.datadog-extra-config}"
    ],
    "mountPoints": [{
      "sourceVolume": "docker-sock",
      "containerPath": "/var/run/docker.sock",
      "readOnly": true
    },{
      "sourceVolume": "proc",
      "containerPath": "/host/proc",
      "readOnly": true
    },{
      "sourceVolume": "cgroup",
      "containerPath": "/host/sys/fs/cgroup",
      "readOnly": true
    }]
  }
]
EOF

  volume {
    name      = "docker-sock"
    host_path = "/var/run/docker.sock"
  }

  volume {
    name      = "proc"
    host_path = "/proc/"
  }

  volume {
    name      = "cgroup"
    host_path = "/cgroup/"
  }
}


