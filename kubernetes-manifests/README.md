# Deployment of Kubernetes objects on the EKS cluster

## Pre-requisites
1. Get relevant AWS credentials (Access Key and Access Secret) to apply terraform locally or input credentials into the relevant Pipeline variables
2. Create S3 bucket and configure as Terraform remote backend to store the relevant Terraform statefile
3. Add the state file related values to to the backend block in the version.tf file once created
4. Create an image of a service to be pulled from AWS ECR to use to spin up containers in pods that will be deployed on the EKS cluster
5. Deploy infrastructure in the above [repository](../)

## Accessing EKS cluster
The EKS cluster is deployed in a private subnet, so can only be managed from 
within the VPC deployed. Spin up an EC2 instance within the VPC, which has
access to the internet to download packages, and do the following installations
(remember to give the EC2 an IAM role to use SSM sessions for better security):

```sh
$ sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
$ sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
$ sudo yum install -y git
$ sudo yum install -y yum-utils
$ sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
$ sudo yum -y install terraform
$ sudo yum -y remove awscli
$ sudo curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
$ sudo unzip awscliv2.zip
$ sudo ./aws/install
$ aws configure
$ aws --version
```

## Deployment from EC2

1. Check the Terraform provided Output, to update your `kubeconfig`

```hcl
Apply complete! Resources: 63 added, 0 changed, 0 destroyed.

Outputs:

configure_kubectl = "aws eks --region eu-west-2 update-kubeconfig --name container-platform-eks-cluster"
```

2. Run `update-kubeconfig` command, using the Terraform provided Output, replace with your `$AWS_REGION` and your `$CLUSTER_NAME` variables.

```sh
aws eks --region <$AWS_REGION> update-kubeconfig --name <$CLUSTER_NAME>
```

3. Test by listing Nodes in in the Cluster.

```sh
kubectl get no
NAME                                        STATUS   ROLES    AGE     VERSION
ip-10-0-19-90.us-west-2.compute.internal    Ready    <none>   8m34s   v1.26.2-eks-a59e1f0
ip-10-0-44-110.us-west-2.compute.internal   Ready    <none>   8m36s   v1.26.2-eks-a59e1f0
ip-10-0-9-147.us-west-2.compute.internal    Ready    <none>   8m35s   v1.26.2-eks-a59e1f0
```

4. Test by listing all the Pods running currently. All the Pods should reach a status of `Running` after approximately 60 seconds:

```sh
kubectl $ kubectl get po -A
NAMESPACE     NAME                       READY   STATUS    RESTARTS   AGE
kube-system   aws-node-jvn9x             1/1     Running   0          7m42s
kube-system   aws-node-mnjlf             1/1     Running   0          7m45s
kube-system   aws-node-q458h             1/1     Running   0          7m49s
kube-system   coredns-6c45d94f67-495rr   1/1     Running   0          14m
kube-system   coredns-6c45d94f67-5c8tc   1/1     Running   0          14m
kube-system   kube-proxy-47wfh           1/1     Running   0          8m32s
kube-system   kube-proxy-f6chz           1/1     Running   0          8m30s
kube-system   kube-proxy-xcfkc           1/1     Running   0          8m31s
```

5. Push an image which cotains a service to private ECR

```sh
podman pull <image>
podman tag <image_name> <ecr_image>
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin <ecr_image>
podman push <ecr_image>
```

6. Deploy service from EC2 instance

```sh
kubectl create deployment nginx --image=<ecr_image>
kubectl create service nodeport nginx --tcp=80:80
curl <$NODE_IP>:<$SERVICE_PORT>
```

## Ingress Controllers

The Kubernetes API object that manages external access to the services deployed
on a Kubernetes cluster, it does this by routiung the traffic by rules it has 
defined in the object. Two widley used ingress controllers, with very different use cases, are [Kong](kong-ingress-controller) and 
[Traefik](traefik-ingress-controller) that can be deployed for a more sophisticated Kubernetes workload.