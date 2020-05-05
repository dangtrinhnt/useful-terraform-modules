variable "mysql_cluster_name" {}

variable "mysql_cluster_username" {}

variable "mysql_cluster_passwd" {}

variable "myservice_db_name" {}

variable "myservice_db_username" {}

variable "myservice_db_passwd" {}

# Use proxy only if your AWS MySQL DB cluster can only be accessible from a bastions
# It's th sock proxy on your computer at port 3306 that connect with the AWS MySQL RDS writer node
#variable "proxy" {
#    default = "socks5://localhost:3306"
#}