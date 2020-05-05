terraform {
  backend "s3" {
    bucket  = "my-terraform"
    key     = "mysql/myservice/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "${var.mysql_cluster_name}"
  username             = "${var.mysql_cluster_username}"
  password             = "${var.mysql_cluster_passwd}"
  parameter_group_name = "default.mysql5.7"
}

resource "mysql_database" "myservice_db" {
  name                  = "${var.myservice_db_name}"
  default_character_set = "utf8mb4"
  default_collation     = "utf8mb4_general_ci"
}

resource "mysql_user" "myservice_db_user" {
  user               = "${var.myservice_db_username}"
  host               = "%"
  plaintext_password = "${var.myservice_db_passwd}"
}

resource "mysql_grant" "myservice_db_grant" {
  user       = "${mysql_user.myservice_db_user.user}"
  host       = "${mysql_user.myservice_db_user.host}"
  database   = "${mysql_database.myservice_db.name}"
  privileges = ["SELECT", "INSERT", "CREATE", "UPDATE", "DELETE"]
}