## Documentation for the bird and birdImage API task

This task was approached using the following steps:

1. The original GitHub repository was forked into my GitHub account - public

2. This was cloned locally, and the APIs were built by running the Makefiles in each API directory using the command (ran from each directory):

```bash
make
```

3. The APIs were ran by running the binary file for each. This showed the relationship between the 2 APIs:

```bash
./getBird
```

```bash
./getBirdImage
```

4. Dockerfile was created for each API using multistage build configuration.

5. With the Dockerfile, the docker image of each API was built and push to Docker registry using the proceeding commands:

```bash
docker build -t <docker-registry-username>/bird-api:1.0 .

docker build -t <docker-registry-username>/birdimage-api:1.0 .
```

```bash
docker login
```

```bash
docker push <docker-registry-username>/bird-api:1.0

docker push <docker-registry-username>/birdimage-api:1.0
``` 

6. A helm chart was created to deploy the APIs to a Kubernetes cluster, with each API having a distinct values file.

7. Infrastructures were provisioned on `AWS` using `Terraform` as `Infrastructure as Code` tool. The infrastructures include:

* VPC

* Public Subnets - for provisioning Application Load balancer

* Private Subnets - for provisioning the instances that will host the Kubernetes cluster for the APIs deployment

* Security groups

* Internet gateway

* Nat gateway

* Route tables and routes

* Launch template - a template that would be used to launch each instance

* Autoscaling group - to automatically scale instance count based on metrics such as CPU and memory utilizations

* Application Load balancer - to route traffic to the instances sitting behind the autoscaling group. The bird API is accessed by using the Load balancer's DNS name, which the terraform configuration will output after it's been applied.

* Cloud watch alarms - which should get triggered when the threshold for each metric is reached so that autoscaling can occur

*** An S3 bucket was created for storing teraform states remotely. Also, a DynamoDB table was created to enable locking when Terraform changes are being applied.

A seperate IAM user is created to give Terraform access to the AWS account and region where resources are created. The credentials are the applied at the terminal before running Terraform commands for the provisioning of resources (required aws cli as well)...

```bash
aws configure
```

```bash
terraform init

terraform plan -var-file=”vars/task.tfvars”

terraform apply -var-file=”vars/task.tfvars”
```

The Terraform commands were ran from within `infrastructures` directory.

Terraform utilizes modules, remote state and state lock. This is to achieve modularity, reusability, collaboration among members of the same team, and the ability for only a member of the team to make changes to resources at a time to avoid conflicts in state management.

**Please note** All logic and files for building, running, dockerizing the APIs is located in `apis` directory, while all resources for deployment of the APIs are located in `kubernetes` directory. The terraform scripts used for provisioning resources can be found in `infrastructures` directory.

