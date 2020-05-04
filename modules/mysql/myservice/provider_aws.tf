provider "aws" {
    alias  = "us-east-1"
    region = "us-east-1"
    version = "~> 1.60"
}

provider "mysql" {
  endpoint = "<aws mysql rds writer node endpoint>:3306"
  username = "${var.master_username}"
  password = "${var.master_password}"
  # proxy    = "${var.proxy}"
}