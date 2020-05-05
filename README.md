# Useful Terraform Modules
Some useful terraform modules to provision services on multiple cloud platforms (e.g., AWS, Azure, GCP, etc.). I started with AWS cloud first and will add support for other cloud platforms later.

- DynamoDB
- MySQL
- Kong

## Usage

### Prerequisites

1. Prepare an AWS IAM account that has permission to create/update the resource you want to deploy

``` sh
$ export AWS_ACCESS_KEY_ID="anaccesskey"
$ export AWS_SECRET_ACCESS_KEY="asecretkey"
$ export AWS_DEFAULT_REGION="us-east-1"
```

2. Install Terraform

Read this [INSTALLATION GUIDE](https://learn.hashicorp.com/terraform/getting-started/install.html#install-terraform)

3. Create a S3 bucket to store Terraform's states.

### Deploy AWS DynamoDB tables

The **dynamodb** module will help you to provision new DynamoDB tables in the AWS infrastructure.

1. Update your DynamoDB table schema at **modules/dynamodb/myservice/main.tf**
2. Provision the table

``` sh
$ cd modules/dynamodb/myservice
$ terraform init
$ terraform plan -var="myservice_table_name=<your table name>"
$ terraform apply -var="myservice_table_name=<your table name>"
```

### Deploy AWS Aurora RDS MySQL databases

You can use the **mysql** module to deploy a new MySQL cluster, then create a new database in that cluster.

1. Update your MySQL cluster information (e.g., version, instance class, etc.), the **default_character_set**, and the **default_collation** of your database at
**modules/dynamodb/myservice/main.tf**
2. Provision your cluster and database

``` sh
$ cd modules/mysql/myservice
$ terraform init
$ terraform plan -var="mysql_cluster_name=<the mysql cluster name you want>" \
                 -var="mysql_cluster_username=<the root username you want>" \
                 -var="mysql_cluster_passwd=<the root passwd you want>" \
                 -var="myservice_db_name=<the db name you want>" \
                 -var="myservice_db_username=<the db username you want>" \
                 -var="myservice_db_passwd=<the db passwd you want>"
$ terraform apply -var="mysql_cluster_name=<the mysql cluster name you want>" \
                 -var="mysql_cluster_username=<the root username you want>" \
                 -var="mysql_cluster_passwd=<the root passwd you want>" \
                 -var="myservice_db_name=<the db name you want>" \
                 -var="myservice_db_username=<the db username you want>" \
                 -var="myservice_db_passwd=<the db passwd you want>"
```

### Deploy Kong

This module will provision these resources:

- An AWS ECS cluster
- AWS ECS tasks for Kong
- AWs autoscaling groups for Kong ECS tasks
- AWS service discovery for Kong
- AWS security groups for accessing Kong
- An AWS network load balancer for Kong
- An AWS application load balancer for Kong

1. Prepare these resources

- app_image: Kong's docker image URL.
- public_subnet_ids: Public subnet IDs
- private_subnet_ids: Private subnet IDS
- vpc_id: the VPC's ID in which you will provision Kong
- cidr_block: VPC's CIDR
- task_role_arn: The IAM role that tasks can use to make API requests to authorized AWS services
- execution_role_arn: This IAM role is required by Fargate tasks to pull container images and publish container logs to Amazon CloudWatch on your behalf
- aws_certificate_arn: AWS certificate's ARN
- aws_acc_id: your AWS account's ID (e.g., 12345678)
- a sub domain for Kong

Note: in this sample module, I assume that you host your domain name on the AWS route53 service.

2. Provision Kong

``` sh
$ cd modules/kong
$ terraform init
$ terraform plan -var="public_subnet_ids=<your public subnet ids>" \
                 -var="private_subnet_ids=<your private subnet ids>" \
                 -var="vpc_id=<your vpc id>" \
                 -var="cidr_block=<your vpc cidr>" \
                 -var="app_image=<your kong image url>" \
                 -var="task_role_arn=<the task role arn>" \
                 -var="execution_role_arn=<the execution role arn>" \
                 -var="aws_certificate_arn=<your aws ssl cert arn>" \
                 -var="aws_acc_id=<your aws acc id>" \
                 -var="domain_name=<your aws hosted domain>"
$ terraform apply -var="public_subnet_ids=<your public subnet ids>" \
                 -var="private_subnet_ids=<your private subnet ids>" \
                 -var="vpc_id=<your vpc id>" \
                 -var="cidr_block=<your vpc cidr>" \
                 -var="app_image=<your kong image url>" \
                 -var="task_role_arn=<the task role arn>" \
                 -var="execution_role_arn=<the execution role arn>" \
                 -var="aws_certificate_arn=<your aws ssl cert arn>" \
                 -var="aws_acc_id=<your aws acc id>" \
                 -var="domain_name=<your aws hosted domain>"
```

## Maintainers

* Trinh Nguyen - [dangtrinhnt](https://www.dangtrinh.com)

## Contribution

You're all welcomed to make PRs.
