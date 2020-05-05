provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
  version = "~> 1.60"
}

provider "mysql" {
  endpoint = "${aws_db_instance.default.endpoint}"
  username = "${aws_db_instance.default.username}"
  password = "${aws_db_instance.default.password}"
  # proxy    = "${var.proxy}"
}