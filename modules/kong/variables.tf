variable "proxy_listen_port" {
    default = 8000
}

variable "proxy_listen_ssl_port"{
    default = 8443
}

variable "admin_listen_port" {
    default = 8001
}

variable "admin_listen_ssl_port" {
    default = 8444
}

variable "public_subnet_ids" {
    type    = "list"
}

variable "private_subnet_ids" {
    type    = "list"
}

variable "vpc_id" {
}

variable "cidr_block"{
}

variable "aws_region" {
    description = "The AWS region to create things in"
    default     = "us-east-1"
}

variable "app_name" {
    description = "The app name"
    default     = "kong"
}

variable "app_env" {
    description = "The app environment to deploy applications"
    default     = "prod"
}

variable "app_port" {
    description = "Port exposed by the docker image to redirect traffic to"
    default     = 8000
}

variable "app_desired_count" {
    description = "Number of containers to run"
    default     = 8
}

variable "fargate_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    default     = "512"
}

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    default     = "1024"
}

variable "app_cpu" {
    description = "The app Container CPU units to provision"
    default     = 512
}

variable "app_memory" {
    description = "The app container MEMORY to provision"
    default     = 1024
}

variable "app_image" {
    description = "The app docker image url"
}

variable "log_group_prefix" {
    description = "CloudWatch log group prefix"
    default     = "mycluster"
}

variable "task_role_arn" {
    description = "The IAM role that tasks can use to make API requests to authorized AWS services."
}

variable "execution_role_arn" {
    description = "This role is required by Fargate tasks to pull container images and publish container logs to Amazon CloudWatch on your behalf."
}

variable "ecs_autoscale_max_instances" {
    default = 8
}

variable "ecs_autoscale_min_instances" {
    default = 8
}

variable "aws_certificate_arn" {
}

variable "aws_acc_id" {
}