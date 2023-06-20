# XYZ-demo
Designed as a demonstration of deploying web services and APIs on Kubernetes
This repository hosts a simple API endpoint, written in Go, the IaC to deploy
Kubernetes on EKS with the requisite infrastructure, and Kubernetes manifests to configure
Ingress and deploy the application, and the Github Action pipelines to deploy it all.

The API returns a JSON formatted message containing the 
unix timestamp and static message to GET requests on /.

## Stack
* Cloud infrastructure provisioned using Terraform, state maintained in AWS s3
* Application and IaC changes tested and built using Github Actions (CI/CD)

### Notable Software
* Web services framework for Golang: Gin Web Framework
* Ingress: Nginx Ingress Controller

### Cloud Services
* Container image registry: AWS Elastic Container Registry and GitHub Container Registry
* Managed Kubernetes: AWS Elastic Kubernetes Service

## Deployment
* Tag and push your release tag
```
git tag v2
git push --tags
```
* Build the release container: From GitHub Actions, select 'Go Build', and run it against the latest tag.
* Tag the release container: From GitHub Actions, select 'Container Release', and run it against the latest tag.
* Build the infrastructure: From GitHub Actions, select 'Terraform', and run it against main.
* Update the image version in the application manifest: `image: jonknutson/xyz-demo:v2`
* Redeploy the application: From GitHub Actions, select 'Apply Kubernetes Manifests', and run it against main.

## Pipeline considerations
### Build and Release Considerations
The Dockerfile builds the app, runs the defined tests, and builds a
minimal container based on alpine.

The Dockerfile takes APP_PORT as an argument, sets the
XYZ_APP_PORT ENV variable, and exposes the provided port.
This is set to 8080 if not provided in by docker build.
A customer port can be specified using a build argument.
- e.g.:
> docker build -t [image-name] --build-arg APP_PORT=[value] .

**Changing the port will require updating the ContainerPort in k8s-config/xyz-demo.yaml**
Regardless of the port on which the container runs, the service can be
accessed over standard HTTP/HTTPS ports, 80/443.

The XYZ_APP_PORT ENV variable is used to set the port on which the
application listens, which defaults to 8080.

For security purposes, the container runs as the user 'nonroot'.

### Troubleshooting the application
For production, the API should run in "release" mode using
the GIN_MODE ENV variable. This is set as the default in the
Dockerfile. For troubleshooting purposes, this can be overridden
either at container build time using build-args, or at container
run-time using environment variables, by setting the mode to debug.
- e.g. using build args
> docker build -t [image-name] --build-arg GIN_MODE=debug .
- e.g. using env:
> export GIN_MODE=debug

## Accessing the deployed API
* When the Ingress Controller (nginx-ingress-controller.yaml) is deployed
it creates a Network Load Balancer. Retrieve the URL of the NLB from AWS.
* The Ingress resource registers the service as a target with the
NLB.
* Access the API through the URL of the NLB:
```
curl my-load-balancer-9475cc03f9cc58c0.elb.us-east-2.amazonaws.com
```

## Clean-up
* Delete K8s resources: From GitHub Actions, select `Shutdown K8s Services`, and run it against main.
* Delete AWS resources: From GitHub Actions, select `Remove Infrastructure`, and run it against main.