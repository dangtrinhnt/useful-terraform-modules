terraform {
  backend "s3" {
    bucket  = "my-terraform"
    key     = "mysql/myservice/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

resource "mysql_database" "myservice_db_name" {
  name                  = "${var.myservice_db_name}"
  default_character_set = "utf8mb4"
  default_collation     = "utf8mb4_general_ci"
}

resource "mysql_user" "myservice_db_user" {
  user               = "${var.myservice_db_username}"
  host               = "%"
  plaintext_password = "${var.myservice_db_password}"
}

resource "mysql_grant" "myservice_db_grant" {
  user       = "${mysql_user.myservice_db_user.user}"
  host       = "${mysql_user.myservice_db_user.host}"
  database   = "${mysql_database.myservice_db_name.name}"
  privileges = ["SELECT", "INSERT", "CREATE", "UPDATE", "DELETE"]
}