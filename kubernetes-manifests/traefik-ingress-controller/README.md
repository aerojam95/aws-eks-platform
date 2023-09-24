# Deployment of Kubernetes objects on the EKS cluster

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
$ sudo curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 > get_helm.sh
$ chmod 700 get_helm.sh
$ ./get_helm.sh
$ helm version --short
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

5. We can now install thr traefik reverse proxy, for ease of deployment we shall use a Helm chart as we have standard deployment, but shall set a number of configutrations reatling to the infrastructure usings the values.yaml file that we have defined:

```sh
$ helm repo add traefik https://helm.traefik.io/traefik
$ helm repo update
$ helm install traefik traefik/traefik --create-namespace --namespace=traefik --values=values.yaml
$ kubectl get pods -n traefik
NAME                       READY   STATUS    RESTARTS   AGE
traefik-7fc5f7dfc7-rmxbv   1/1     Running   0          12m
```

6. We can now expoise some services. We shall create an IngressRoute object for the Traefik dashboard which will have an auth middleware componet for accessing the endpoints. The following files shall be used  secret.yaml, middleware.yaml, and ingress-route.yaml:

```sh
$ kubectl create -f secret.yaml -f middleware.yaml -f ingress-route.yaml 
$ kubectl get service -n traefik
NAME      TYPE           CLUSTER-IP      EXTERNAL-IP                                                              PORT(S)                      AGE
traefik   LoadBalancer   10.100.194.78   <EXTERNAL-IP>                                                            80:31693/TCP,443:31136/TCP   72s
```

7. Using the <EXTERNAL-IP> of the load balancer service deployed from the Helm chart and just modified you can view the Traefik dashboard:

```sh
http://<EXTERNAL-IP>/dashboard
```

8. Exposing a service of a web application you want to deploy will be done with an Ingress Kubernetes object. Firstly deploy a web application and a service using whoami.yaml:

```sh
$ kubectl apply -f whoami.yaml
$ kubectl get pods -n traefik
NAME                       READY   STATUS    RESTARTS   AGE
traefik-7fc5f7dfc7-rmxbv   1/1     Running   0          12m
whoami-75d5976d8d-vmpfw    1/1     Running   0          23s
```

9. Create an Ingress object to route the traffic to your newly deployed web application sercvice with ingres.yaml:

```sh
$ kubectl apply -f ingress.yaml
```

10. Test that you can access your web application using the traefik loadbalancer <EXTERNAL-IP> and ingress prefix:

```sh
$ curl -v -u test:password <EXTERNAL-IP>/whoami
* processing: <EXTERNAL-IP>/whoami
*   Trying 99.81.14.23:80...
* Connected to <EXTERNAL-IP> (99.81.14.23) port 80
* Server auth using Basic with user 'test'
> GET /whoami HTTP/1.1
> Host: <EXTERNAL-IP>
> Authorization: Basic dGVzdDpwYXNzd29yZA==
> User-Agent: curl/8.2.1
> Accept: */*
>
< HTTP/1.1 200 OK
< Content-Length: 584
< Content-Type: text/plain; charset=utf-8
< Date: Sun, 24 Sep 2023 10:06:07 GMT
<
Hostname: whoami-6c858d6598-vhz6l
IP: 127.0.0.1
IP: ::1
IP: 10.0.1.208
IP: fe80::2440:d6ff:fe2e:96e0
RemoteAddr: 10.0.1.129:55910
GET /whoami HTTP/1.1
Host: <EXTERNAL-IP>
User-Agent: curl/8.2.1
Accept: */*
Accept-Encoding: gzip
Authorization: Basic dGVzdDpwYXNzd29yZA==
X-Forwarded-For: 10.0.2.153
X-Forwarded-Host: <EXTERNAL-IP>
X-Forwarded-Port: 80
X-Forwarded-Proto: http
X-Forwarded-Server: traefik-58644b69ff-tdcpk
X-Real-Ip: 10.0.2.153

* Connection #0 to host <EXTERNAL-IP> left intact
```

11. The Traefik reverse proxy can now be used and the only change to be done is to the deployment, service, and ingress for your given web application you wish to deploy

12. This setup was followed and modified by following the the Traefik documentation [Using Traefik Proxy as the Ingress Controller](https://community.traefik.io/t/using-traefik-proxy-as-the-ingress-controller-traefik-labs/15464/1), the principal modification was the change of container image on the web application from traefik/whoami to containous/whoami as the proposed image was not working correctly, as can be seen on [here](https://stackoverflow.com/questions/62780325/traefik-v2-2-ingress-route-example-not-working), and the alternative one provides the expected results in this documentation