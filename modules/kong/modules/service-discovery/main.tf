resource "aws_service_discovery_private_dns_namespace" "main" {
    name        = "${var.app_env}"
    description = "The service discovery service for MSA services"
    vpc         = "${var.vpc_id}"
}

resource "aws_service_discovery_service" "main" {
    name = "${var.app_name}"

    dns_config {
        namespace_id = "${aws_service_discovery_private_dns_namespace.main.id}"
        dns_records {
            ttl  = 300
            type = "A"
        }
        routing_policy = "MULTIVALUE"
    }

    health_check_custom_config {
        failure_threshold = 1
    }

    lifecycle {
      create_before_destroy = true
    }
}
