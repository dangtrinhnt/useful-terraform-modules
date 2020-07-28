# Provision an EKS Cluster

This repo contains Terraform configuration files to provision an EKS cluster on AWS.

After installing the AWS CLI. Configure it to use your credentials.

```shell
$ aws configure
AWS Access Key ID [None]: <YOUR_AWS_ACCESS_KEY_ID>
AWS Secret Access Key [None]: <YOUR_AWS_SECRET_ACCESS_KEY>
Default region name [None]: <YOUR_AWS_REGION>
Default output format [None]: json
```

This enables Terraform access to the configuration file and performs operations on your behalf with these security credentials.

Update the variables.tf file, map_users, with your desired IAM accounts you want to
grant admin privileges to your EKS cluster.

After you've done this, initalize your Terraform workspace, which will download 
the provider and initialize it with the values provided in the `terraform.tfvars` file.

```shell
$ terraform init
```

Then, provision your EKS cluster by running `terraform apply`. This will 
take approximately 10 minutes.

```shell
$ terraform apply -var 'profile=<your aws credential profile>' -var 'cluster_name=<eks cluser name>' \
-var 'vpc_name=<vpc name>' -var 'key_name=<pem key to access the worker nodes>' -var 'region=<your refered region>'
```

## Configure kubectl

To configure kubetcl, you need both [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) and [AWS IAM Authenticator](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html).

The following command will get the access credentials for your cluster and automatically
configure `kubectl`.

```shell
$ aws eks --region <your aws region> update-kubeconfig --name <your eks cluster name>
```

The Kubernetes cluster name and region correspond to the output variables showed
after the successful Terraform run.

You can view these outputs again by running:

```shell
$ terraform output
```
