variable "family" {}
variable "revision" {}
variable "app_env" {}
variable "ecs_cluster_name" {}
variable "app_name" {}
variable "app_port" {}
variable "cluster_id" {}
variable "app_desired_count" {}
variable "security_group_id" {}
variable "subnet_ids" {
  type = "list"
}
variable "target_group_id" {}
variable "container_name" {}
variable "service_discovery_service_arn" {}

variable "ecs_as_cpu_high_threshold_per" {
  default = "60"
}

variable "ecs_as_cpu_low_threshold_per" {
  default = "20"
}

variable "ecs_autoscale_max_instances" {
  default = "8"
}

variable "ecs_autoscale_min_instances" {
  default = "8"
}
