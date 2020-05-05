terraform {
  required_version = ">= 0.9.3, != 0.9.5"
  backend "s3" {
      bucket  = "my-terraform"
      key     = "kong/terraform.tfstate"
      region  = "us-east-1"
      encrypt = true
  }
}

module "ecs_cluster" {
  source  = "./modules/ecs-cluster"
  app_env = "${var.app_env}"
}

data "aws_route53_zone" "main" {
  name = "${var.domain_name}."
}

resource "aws_route53_record" "kong" {
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "${var.app_env}api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = "${module.alb.lb_domain_name}"
    zone_id                = "${module.alb.lb_zone_id}"
    evaluate_target_health = true
  }
}

module "alb" {
  source            = "./modules/alb"
  subnet_ids        = "${var.public_subnet_ids}"
  vpc_id            = "${var.vpc_id}"
  app_name          = "${var.app_name}"
  app_env           = "${var.app_env}"
  certificate_arn   = "${var.aws_certificate_arn}"
  alb_account_id    = "${var.aws_acc_id}"
  app_port          = "${var.app_port}"
}

module "cloudwatch" {
  source = "./modules/cloudwatch"
  app_name = "${var.app_name}"
  app_env  = "${var.app_env}"
}

module "security_group" {
  source                = "./modules/security-group"
  app_env               = "${var.app_env}"
  app_name              = "${var.app_name}"
  proxy_listen_port     = "${var.proxy_listen_port}"
  proxy_listen_ssl_port = "${var.proxy_listen_ssl_port}"
  admin_listen_port     = "${var.admin_listen_port}"
  admin_listen_ssl_port = "${var.admin_listen_ssl_port}"
  cidr_block            = "${var.cidr_block}"
  vpc_id                = "${var.vpc_id}"
}

module "service_discovery" {
  source   = "./modules/service-discovery"
  app_name = "${var.app_name}"
  app_env  = "${var.app_env}"
  vpc_id   = "${var.vpc_id}"
}

module "kong_task_definition" {
  source             = "./modules/task-definition"
  app_name           = "${var.app_name}"
  app_env            = "${var.app_env}"
  app_cpu            = "${var.app_cpu}"
  app_memory         = "${var.app_memory}"
  app_image          = "${var.app_image}"
  aws_region         = "${var.aws_region}"
  fargate_cpu        = "${var.fargate_cpu}"
  fargate_memory     = "${var.fargate_memory}"
  task_role_arn      = "${var.task_role_arn}"
  execution_role_arn = "${var.execution_role_arn}"
  log_group_prefix   = "${var.log_group_prefix}"
}

module "kong_service" {
  source                        = "./modules/service"
  family                        = "${module.kong_task_definition.family}"
  revision                      = "${module.kong_task_definition.revision}"
  app_env                       = "${var.app_env}"
  ecs_cluster_name              = "${module.ecs_cluster.cluster_name}"
  app_name                      = "${var.app_name}"
  app_port                      = "${var.app_port}"
  cluster_id                    = "${module.ecs_cluster.cluster_id}"
  app_desired_count             = "${var.app_desired_count}"
  security_group_id             = "${module.security_group.security_group_id}"
  subnet_ids                    = "${var.private_subnet_ids}"
  target_group_id               = "${module.alb.target_group_id}"
  container_name                = "${var.app_name}"
  service_discovery_service_arn = "${module.service_discovery.service_discovery_service_arn}"
  ecs_autoscale_max_instances   = "${var.ecs_autoscale_max_instances}"
  ecs_autoscale_min_instances   = "${var.ecs_autoscale_min_instances}"
}
