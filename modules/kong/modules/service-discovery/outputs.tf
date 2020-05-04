output service_discovery_service_arn {
  value = "${aws_service_discovery_service.main.arn}"
}

output service_discovery_private_dns_namespace_id {
  value ="${aws_service_discovery_private_dns_namespace.main.id}"
}
