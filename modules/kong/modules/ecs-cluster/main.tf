resource "aws_ecs_cluster" "main" {
  name = "my-${var.app_env}-cluster"
}
