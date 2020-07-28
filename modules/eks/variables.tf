variable "profile" {
  description = "aws account profile"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = ""
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster."
  type        = string
  default     = "1.16"
}

variable "vpc_name" {
  description = "VPC where the cluster and workers will be deployed."
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Key pair name to access worker nodes"
  type        = string
  default     = ""
}

variable "region" {
  default = "ap-southeast-1"
}


variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::123456789:user/account1"
      username = "account1"
      groups   = ["system:masters"]
    },
    {
      userarn  = "arn:aws:iam::123456789:user/account2"
      username = "account2"
      groups   = ["system:masters"]
    },
  ]
}