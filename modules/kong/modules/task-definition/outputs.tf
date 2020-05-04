output "family" {
  value = "${aws_ecs_task_definition.kong.family}"
}

output "revision" {
  value = "${aws_ecs_task_definition.kong.revision}"
}
