terraform {
    backend "s3" {
        bucket  = "my-terraform"
        key     = "myservice/dynamodb/terraform.tfstate"
        region  = "us-east-1"
        encrypt = true
    }
}


resource "aws_dynamodb_table" "myservice-us-east-1" {
    provider = "aws.us-east-1"

    name           = "${var.myservice_table_name}"
    hash_key       = "service_name"
    read_capacity  = 50
    write_capacity = 5

    attribute = [
      {
        name = "service_name"
        type = "S"
      },{
        name = "id"
        type = "S"
      }
    ]

    global_secondary_index {
      name               = "id_index"
      hash_key           = "id"
      read_capacity      = 50
      write_capacity     = 5
      projection_type    = "ALL"
    }

    tags {
      Name        = "${var.myservice_table_name}"
    }

    stream_enabled = true
    stream_view_type = "NEW_AND_OLD_IMAGES"

    point_in_time_recovery {
      enabled = true
    }

    lifecycle {
      ignore_changes = ["read_capacity"]
    }
}
