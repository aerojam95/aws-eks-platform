# aws-eks-container-platform

## Description
Terraform for creating an AWS EKS fargate container platform

![Container Platform](docs/eks-container-platform.png)

## Key infrastructure

| Name | Description |
|------|------|
| [ecs-service-fargate](https://github.com/terraform-aws-modules/terraform-aws-ecs.git) | ECS fargate service where workloads are orchestrated and defined |
| [kms-keys](https://github.com/terraform-aws-modules/terraform-aws-kms.git) | Encryption for the CloudWatch log groups of ECS service and task logs  |


## Pre-requisite
1. Get relevant AWS credentials (Access Key and Access Secret) to apply terraform locally or input credentials into the relevant Pipeline variables

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