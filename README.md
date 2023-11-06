# Task Description

```
The Test is the following:
Part 1
Write a simple “Hello World” web application using any language or framework of your choice
Write a Dockerfile to package the web application as a container
Write a Helm chart to deploy this container as a web application
Part 2
In a few words, describe how you provision cloud infrastructure from scratch to host this application with High Availability in mind. (Output should not be code, but a description in your own words). Some topics you might want to include:
Cloud of choice
Infrastructure design and components
Automation and deployment
In a few words, describe how you would create a continuous delivery pipeline to automatically build and deploy this application to dev --> staging --> prod environments with every Git push. (Output should not be code, but a description in your own words). Some topics you might want to include:
CI/CD tool of choice and setup
Procedural build steps
Procedural deployment steps
```

# Part 1

## Development

The _helloworld_ application is developed in Python, using Pipenv as a package manager. Flask framework is utilized to serve http.

Commands 
```
cd app
pipenv install
python -m flask run --host=0.0.0.0
```

## Container

Container is built using _podman_. Check file `build.sh`.


# Part 2

## Infrastructure Plan

A Kubernetes cluster will be created in AWS using their EKS offer, spanning two availability zones for high availability. Fargate may be an option too.

Terraform (optional Terragrunt) will be used for provisioning:

1. Uses AWS provider
    1. VPC 
    1. Availability Zone A - Nat Gateway or Internet Gateway
    1. Availability Zone B - Nat Gateway or Internet Gateway
    1. EKS cluster is created using "managed node groups" defined for __each__ availability zone.
        1. The cluster can have a public or private API endpoint. Delivery pipeline (next section) will require public endpoint.
    1. DNS entries, if required
    1. IAM policy for ALB ingress controller
1. Uses Kubernetes provider
    1. Deploy ALB ingress controller

Terraform code is "multi environment" and above resources will be created for each environment. Production environment may have >2 availability zones.


## Delivery pipeline

The tool of choice for continuous delivery is Github Actions. Three branches will be created reflecting the environments:

* Development
* Staging
* Production

Github Action's Workflows will be created, which react on every push. Each environment will have a set of _secrets_, notoriously the IAM access keys for AWS. The IAM user will permit to fetch kubeconfig file which in turn will permit `kubectl` based actions.
Production branch will be a "protected branch", that will require human approval. The pipeline will use pre-created actions like:

* checkout
* terraform
* python
* pipenv
* configure-aws-credentials

### Build steps
1. execute `build.sh`

### Deploy steps
1. Execute helm action, passing the value of `image.repository` and `image.tag`.






