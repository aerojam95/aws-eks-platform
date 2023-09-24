# Deployment of Kong ingress controller Kubernetes objects on the EKS cluster

## Pre-requisites
1. Get relevant AWS credentials (Access Key and Access Secret) to apply terraform locally or input credentials into the relevant Pipeline variables
2. Create S3 bucket and configure as Terraform remote backend to store the relevant Terraform statefile
3. Add the state file related values to to the backend block in the version.tf file once created
4. Create an image of a service to be pulled from AWS ECR to use to spin up containers in pods that will be deployed on the EKS cluster
5. Deplpoy infrastructure in the above [repository](../../)

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
$ aws eks --region <$AWS_REGION> update-kubeconfig --name <$CLUSTER_NAME>
```

3. Test by listing Nodes in in the Cluster.

```sh
$ kubectl get no
NAME                                        STATUS   ROLES    AGE     VERSION
ip-10-0-19-90.us-west-2.compute.internal    Ready    <none>   8m34s   v1.26.2-eks-a59e1f0
ip-10-0-44-110.us-west-2.compute.internal   Ready    <none>   8m36s   v1.26.2-eks-a59e1f0
ip-10-0-9-147.us-west-2.compute.internal    Ready    <none>   8m35s   v1.26.2-eks-a59e1f0
```

4. Test by listing all the Pods running currently. All the Pods should reach a status of `Running` after approximately 60 seconds:

```sh
$ kubectl get po -A
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

5. Deploy Kong ingress controller, this could take up to 5 minutes on initial deployment:

```sh
$ kubectl create -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v2.11.0/deploy/single/all-in-one-dbless.yaml
namespace/kong created
customresourcedefinition.apiextensions.k8s.io/kongplugins.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongconsumers.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongcredentials.configuration.konghq.com created
customresourcedefinition.apiextensions.k8s.io/kongingresses.configuration.konghq.com created
serviceaccount/kong-serviceaccount created
clusterrole.rbac.authorization.k8s.io/kong-ingress-clusterrole created
clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-clusterrole-nisa-binding created
configmap/kong-server-blocks created
service/kong-proxy created
service/kong-validation-webhook created
deployment.extensions/kong created
```

6. We need an environment variable with the IP address at which Kong is accessible, this IP address sends requests to the Kubernetes cluster API. Execute the following command to get the IP address at which Kong is accessible:

```sh
$ kubectl get services -n kong
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP                           PORT(S)                      AGE
kong-proxy   LoadBalancer   10.63.250.199   example.eu-west-1.elb.amazonaws.com   80:31929/TCP,443:31408/TCP   57d
```

7. Create an environment variable to hold the ELB hostname:

```sh
$ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].hostname}" service -n kong kong-proxy)
```

8. The hostname cannot be used a target IP address in the comming steps, so we need to get the necessary target IP addresses, it will take time for these hostnames to resolve and obtian the corresponding IP addresses:

```sh
$ getent hosts $PROXY_IP
xxx.xxx.xxx.xxx   example.eu-west-1.elb.amazonaws.com
xxx.xxx.xxx.xxx   example.eu-west-1.elb.amazonaws.com
xxx.xxx.xxx.xxx   example.eu-west-1.elb.amazonaws.com
```

9. Check Kong Gateway connectivity:

```sh
$ curl -i $PROXY_IP
HTTP/1.1 404 Not Found
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 48
X-Kong-Response-Latency: 0
Server: kong/3.0.0

{"message":"no Route matched with those values"}
```

10. Create the Kong deployment and the Kong service to serve the pods of the deployment:

```sh
$ kubectl create -f kong-service.yml -f kong-deployment.yml
service/echo created
deployment.apps/echo created
 ```

 11. Ingress controllers need a configuration that indicates which set of routing configuration they should recognize. This allows multiple controllers to coexist in the same cluster. Before creating individual routes, you need to create a class configuration to associate routes with:

 ```sh
 $ kubectl create -f kong-ingress-class.yml
 ingressclass.networking.k8s.io/kong configured
 ```

 12. Create routing configuration to proxy /echo requests to the echo server:
 
 ```sh
 $ kubectl create -f kong-ingress.yml
 ingress.networking.k8s.io/echo created
 ```

 13. Test the routing rule:

```sh
$ curl -i http://kong.example/echo --resolve kong.example:80:$PROXY_IP
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Length: 140
Connection: keep-alive
Date: Fri, 21 Apr 2023 12:24:55 GMT
X-Kong-Upstream-Latency: 0
X-Kong-Proxy-Latency: 1
Via: kong/3.2.2

Welcome, you are connected to node docker-desktop.
Running on Pod echo-7f87468b8c-tzzv6.
In namespace default.
With IP address 10.1.0.237.
...
```

14. The Kong ingress controller is deployed this can be editted now to route traffic to services as you wish and can modify the service and deployment files as needed for your task

15. This setup was followed and modified by following the two guides provided by the Kong documentation the first being [Kong Deployment on EKS](https://docs.konghq.com/kubernetes-ingress-controller/latest/deployment/eks/) and the second being [Kong configuration for EKS](https://docs.konghq.com/kubernetes-ingress-controller/2.11.x/guides/getting-started/#add-routing-configuration)