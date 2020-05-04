output target_group_id {
  value = "${aws_lb_target_group.main.id}"
}

output lb_domain_name {
  value = "${aws_lb.main.dns_name}"
}

output lb_zone_id {
  value = "${aws_lb.main.zone_id}"
}

output lb_name {
  value = "alb-my-${var.app_env}-kong"
}
