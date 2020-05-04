resource "aws_ecs_task_definition" "kong" {
    family = "${var.app_name}-${var.app_env}"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "${var.fargate_cpu}"
    memory = "${var.fargate_memory}"
    task_role_arn = "${var.task_role_arn}"
    execution_role_arn = "${var.execution_role_arn}"
    container_definitions = <<DEFINITION
    [
        {
            "cpu": ${var.app_cpu},
            "memory": ${var.app_memory},
            "essential": true,
            "image": "${var.app_image}",
            "name": "${var.app_name}",
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/${var.app_env}/${var.app_name}",
                    "awslogs-region": "${var.aws_region}",
                    "awslogs-stream-prefix": "${var.log_group_prefix}"
                }
            },
            "portMappings": [
                {
                    "hostPort": 8000,
                    "protocol": "tcp",
                    "containerPort": 8000
                },
                {
                    "hostPort": 8443,
                    "protocol": "tcp",
                    "containerPort": 8443
                },
                {
                    "hostPort": 8001,
                    "protocol": "tcp",
                    "containerPort": 8001
                },
                {
                    "hostPort": 8444,
                    "protocol": "tcp",
                    "containerPort": 8444
                }
            ],
            "environment": [],
            "ulimits": [
                {
                    "name": "nofile",
                    "softLimit": 4096,
                    "hardLimit": 4096
                }
            ],
            "dockerLabels": {
                "Name": "${var.app_name}",
                "Env": "${var.app_env}"
            }
        }
    ]
    DEFINITION
}
