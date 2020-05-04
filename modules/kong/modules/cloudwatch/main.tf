resource "aws_cloudwatch_log_group" "main" {
    name              = "/${var.app_env}/${var.app_name}"
    retention_in_days = 30
    tags {
        Name = "${var.app_name}"
    }
}
