resource "aws_lb" "main" {
    name               = "nlb-my-${var.app_env}-kong"
    internal           = false
    load_balancer_type = "network"
    subnets            = "${var.subnet_ids}"

    enable_deletion_protection = true

}

resource "aws_lb_target_group" "main" {
    name        = "${var.app_env}-${var.app_name}-tg"
    port        = "80"
    protocol    = "TCP"
    vpc_id      = "${var.vpc_id}"
    target_type = "ip"
}

resource "aws_lb_listener" "main" {
    load_balancer_arn = "${aws_lb.main.id}"
    port              = "80"
    protocol          = "TCP"

    default_action {
        target_group_arn = "${aws_lb_target_group.main.id}"
        type             = "forward"
    }
}
