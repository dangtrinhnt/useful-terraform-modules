
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  alarm_name          = "${var.app_env}-${var.app_name}-CPU-Utilization-High-${var.ecs_as_cpu_high_threshold_per}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "${var.ecs_as_cpu_high_threshold_per}"

  dimensions {
      # TODO
      ClusterName = "${var.ecs_cluster_name}"
      ServiceName = "${aws_ecs_service.main.name}"
  }

  alarm_actions = ["${aws_appautoscaling_policy.app_up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_low" {
  alarm_name          = "${var.app_env}-${var.app_name}-CPU-Utilization-Low-${var.ecs_as_cpu_low_threshold_per}"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "${var.ecs_as_cpu_low_threshold_per}"

  dimensions {
      # TODO
      ClusterName = "${var.ecs_cluster_name}"
      ServiceName = "${aws_ecs_service.main.name}"
    }

  alarm_actions = ["${aws_appautoscaling_policy.app_down.arn}"]
}

resource "aws_appautoscaling_target" "app_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  max_capacity       = "${var.ecs_autoscale_max_instances}"
  min_capacity       = "${var.ecs_autoscale_min_instances}"
}

resource "aws_appautoscaling_policy" "app_up" {
  name               = "app-scale-up"
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 2
    }
  }

  depends_on = [
    "aws_appautoscaling_target.app_scale_target",
  ]
}

resource "aws_appautoscaling_policy" "app_down" {
  name               = "app-scale-down"
  service_namespace  = "ecs"
  #TODO
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -2
    }
  }

  depends_on = [
    "aws_appautoscaling_target.app_scale_target",
  ]
}

data "aws_ecs_task_definition" "kong" {
    task_definition = "${var.family}"
}

resource "aws_ecs_service" "main" {
    name            = "${var.app_name}"
    cluster         = "${var.cluster_id}"
    task_definition = "${var.family}:${max("${var.revision}", "${data.aws_ecs_task_definition.kong.revision}")}"
    desired_count   = "${var.app_desired_count}"
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = ["${var.security_group_id}"]
        subnets          = "${var.subnet_ids}"
        assign_public_ip = "false"
    }

    load_balancer {
        target_group_arn = "${var.target_group_id}"
        container_name   = "${var.container_name}"
        container_port   = "${var.app_port}"
    }

    service_registries {
        registry_arn = "${var.service_discovery_service_arn}"
    }

    lifecycle {
      ignore_changes = ["desired_count"]
    }
}
