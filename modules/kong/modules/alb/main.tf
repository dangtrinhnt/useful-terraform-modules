resource "aws_s3_bucket" "main" {
  bucket = "my-${var.app_env}-kong-alb"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.alb_account_id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::my-${var.app_env}-kong-alb/*"
    }
  ]
}
  EOF

  lifecycle_rule {
    id      = "log_lifecycle"
    prefix  = ""
    enabled = true

    transition {
      days          = 30
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

  tags {
    Name = "my-${var.app_env}-kong-alb"
  }
}

resource "aws_security_group" "lb" {
  name        = "my-${var.app_env}-alb-sg"
  description = "controls access to the ${var.app_env} ALB"
  vpc_id      = "${var.vpc_id}"

  ingress {
    protocol  = "tcp"
    from_port = "443"
    to_port   = "443"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "main" {
  name               = "alb-my-${var.app_env}-kong"
  internal           = false
  load_balancer_type = "application"
  subnets            = "${var.subnet_ids}"

  enable_deletion_protection = true

  access_logs {
    bucket  = "${aws_s3_bucket.main.bucket}"
    prefix  = "alb"
    enabled = true
  }

  security_groups = ["${aws_security_group.lb.id}"]

  tags {
    Environment = "${var.app_env}"
  }

  lifecycle { create_before_destroy = true }

}

resource "random_string" "target_group" {
  length = 8
    special = false
}


resource "aws_lb_target_group" "main" {
  name        = "${var.app_env}-${var.app_name}-tg-${random_string.target_group.result}"
  port        = "${var.app_port}"
  protocol    = "HTTP"
  vpc_id      = "${var.vpc_id}"
  target_type = "ip"

  health_check {
    path    = "/"
    port    = 8001
    matcher = "200-299"
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes = ["name"]
  }
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = "${aws_lb.main.arn}"
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  certificate_arn = "${var.certificate_arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.main.id}"
    type             = "forward"
  }
}

