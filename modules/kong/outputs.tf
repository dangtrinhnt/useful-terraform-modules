output service_discovery_private_dns_namespace_id {
  value = "${module.service_discovery.service_discovery_private_dns_namespace_id}"
}

output lb_domain_name {
  value = "${module.alb.lb_domain_name}"
}

output lb_name {
  value = "${module.alb.lb_name}"
}

output domain_name {
  value = "${aws_route53_record.kong.name}"
}

output cluster_name {
  value = "${module.ecs_cluster.cluster_name}"
}
