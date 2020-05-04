resource "aws_security_group" "main" {
    name        = "my-${var.app_env}-${var.app_name}-sg"
    description = "allow inbound access form the NLB only"
    vpc_id      = "${var.vpc_id}"

    ingress {
        protocol    = "tcp"
        from_port   = "${var.proxy_listen_port}"
        to_port     = "${var.proxy_listen_port}"
        cidr_blocks = ["${var.cidr_block}"]
    }

    ingress {
        protocol    = "tcp"
        from_port   = "${var.proxy_listen_ssl_port}"
        to_port     = "${var.proxy_listen_ssl_port}"
        cidr_blocks = ["${var.cidr_block}"]
    }

    ingress {
        protocol    = "tcp"
        from_port   = "${var.admin_listen_port}"
        to_port     = "${var.admin_listen_port}"
        cidr_blocks = ["${var.cidr_block}"]
    }

    ingress {
        protocol    = "tcp"
        from_port   = "${var.admin_listen_ssl_port}"
        to_port     = "${var.admin_listen_ssl_port}"
        cidr_blocks = ["${var.cidr_block}"]
    }

    egress {
        protocol    = -1
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}
