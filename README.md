# aws-eks-container-platform

## Description
Terraform for creating an AWS EKS private container platform

![Container Platform](docs/eks-container-platform.png)

## Key infrastructure

| Name | Description |
|------|------|
| [vpc]( https://github.com/terraform-aws-modules/terraform-aws-vpc.git) | VPC such that infrastructure is secured on a networking level |
| [vpc-endpoints](https://github.com/terraform-aws-modules/terraform-aws-vpc.git) | Give the VPC access to AWS the required services  |
| [S3-bucket](https://github.com/terraform-aws-modules/terraform-aws-s3-bucket.git) | Logging the CloudTrail trail |
| [kms-keys](https://github.com/terraform-aws-modules/terraform-aws-kms.git) | Encryption for S3 bucket for logging of CloudTaril, encryption to the CloudWatch log groups for CloudTrail trail, VPC flow logs, and EKS cluster |
| [cloudtrail-trail](https://github.com/cloudposse/terraform-aws-cloudtrail.git) | Audit loggging for infrastructure |
| [iam-roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | Gives services, relevant permissions, and creates an admin role for administration |
| [eks-cluster](https://github.com/terraform-aws-modules/terraform-aws-eks.git) | EKS cluster where workloads will be computed |

## Private cluster

This example demonstrates how to deploy an Amazon EKS cluster that is deployed on the AWS Cloud in private subnets. For that, your cluster must pull images from a container registry that's in your VPC, and also must have endpoint private access enabled. This is required for nodes to register with the cluster endpoint.

Please see this [document](https://docs.aws.amazon.com/eks/latest/userguide/private-clusters.html) for more details on configuring fully private EKS Clusters.

For fully Private EKS clusters requires the following VPC endpoints to be created to communicate with AWS services. This example solution will provide these endpoints if you choose to create VPC. If you are using an existing VPC then you may need to ensure these endpoints are created.

    com.amazonaws.region.ssm                       - Secrets Management
    com.amazonaws.region.ssmmessages               - Secrets Monitoring
    com.amazonaws.region.ec2                       - EC2 Management
    com.amazonaws.region.ec2messages               - EC2 Monitoring
    com.amazonaws.region.kms                       - KMS Management
    com.amazonaws.region.ecr.api                   - ECR API calls
    com.amazonaws.region.ecr.dkr                   - ECR Docker Images
    com.amazonaws.region.logs                      - For CloudWatch Logs
    com.amazonaws.region.sts                       - If using AWS Fargate or IAM roles for service accounts
    com.amazonaws.region.elasticloadbalancing      - If using Application Load Balancers
    com.amazonaws.region.autoscaling               - If using Cluster Autoscaler
    com.amazonaws.region.s3                        - Creates S3 Gateway


## Pre-requisites
1. Get relevant AWS credentials (Access Key and Access Secret) to apply terraform locally or input credentials into the relevant Pipeline variables
2. Create S3 bucket and configure as Terraform remote backend to store the relevant Terraform statefile
3. Add the state file related values to to the backend block in the version.tf file once created
4. Create an image of a service to be pulled from AWS ECR to use to spin up containers in pods that will be deployed on the EKS cluster

## Usage
```sh
terraform init
terraform fmt
terraform valiate
terraform plan -out=$PLAN
terraform apply -input=false --auto-approve $PLAN
terraform plan -destroy -out=$DESTROY
terraform apply -input=false --auto-approve $DESTROY
```