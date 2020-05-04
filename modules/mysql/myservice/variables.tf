variable "master_username" {}

variable "master_password" {}

variable "myservice_db_name" {
    default = "myservice_db"
}

variable "myservice_db_username" {}

variable "myservice_db_password" {}

# Use proxy only if your AWS MySQL DB cluster can only be accessible from a bastions
# It's th sock proxy on your computer at port 3306 that connect with the AWS MySQL RDS writer node
#variable "proxy" {
#    default = "socks5://localhost:3306"
#}