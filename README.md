## [[Superfluid](https://www.superfluid.finance) - Continuously deploy ECS Cluster w/ Sentinel]

This is a CI/CD project to continuously deploy a [Superfluid Sentinel](https://github.com/superfluid-finance/superfluid-sentinel) (The sentinel monitors the state of Superfluid agreements on the configured network and liquidates critical agreements) image to an Amazon Elastic Container Service (ECS) via Terraform.

I also created some other structures in which are not being managed on this repository (Identity Provider to allow Github Actions perform what is necessary regarding create/delete infra into AWS) and the S3 Bucket for the Terrform State (This is a remote tf project, this means that the tf.state is being stored remotely into a S3 Bucket)

## Project Folder Structure

```
── README.md
── .gitignore
├── .extra
│   ├── nix
│   │   └── superfluid-sentinel.nix
│   └── aws
│       └── role-trusted-entity.json
│
├── .github/workflows
│   └── terraform-ci.yml # Main CI/CD file w/ branch rules
│
├── terraform
│   ├── modules
│   │   └── vpc
│   │       ├── main.tf
│   │       └── variables.tf
│   │   └── ecs
│   │       ├── main.tf
│   │       ├── subnets.tf
│   │       ├── internet-gateway.tf
│   │       ├── outputs.tf
│   │       ├── variables.tf
│   │       └── loadbalancer.tf # Optional Configs for ALB
│   │   └── ecs-task
│   │       ├── execution-role.tf
│   │       ├── security-group.tf
│   │       ├── cloudwatch.tf
│   │       ├── service.tf
│   │       ├── variables.tf
│   │       └── task-definition.tf
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   └── .gitignore
```

## Secrets and Variables - Actions

To run the CI/CD w/ GT Actions for remote Terraform projects, we store the tf.state into a s3 bucket. But in order to access it (also create/delete structures), i created an AWS Identity provider (not managed on this repo) for Git. For this reason, we must to create the secrets bellow on Github actions:

```
AWS_BUCKET_KEY_NAME
AWS_BUCKET_NAME
AWS_REGION
AWS_ROLE
```

## CI/CD Automation - Github Actions ~> Terraform ~> AWS

We are using a S3 Bucket to store the tf.state. You can take a better look into the architecture bellow:

<img src="https://media.cloudscalr.com/images/github-oidc-terraform/architecture1.png"  />
> Open ID protocol with AWS Identity Provider

## Superfluid Sentinel ECR Image

This solution is designed to read images from an Amazon Elastic Container Registry (Amazon ECR) and use it into the Task Definition. For this example, i deployed (not managed on this repo) the Superfluid Sentinel image to my own ECR repo and gave access for the ECS (security group for task execution role) access it

Code example:

```
terraform/modules/ecs-task/task-definition.tf
...
 container_definitions = <<DEFINITION
[
  {
    "image": "public.ecr.aws/i0x4j1n5/superfluid-sentinel:latest", # HERE WE HAVE THE ECR REPO
    "cpu": 256,
    "memory": 1024,
    "name": "superfluid-sentinel",
...
```

## Application Logs - Cloud Monitoring Platform (CloudWatch)

One of the most important things related to the Superfluid Sentinel is the Log visualization. For this reason, i also deployed a private CloudWatch Log Group for our ECS app. This way we can check the logs in real time.

![](https://i.imgur.com/0FOQPZl.png)

> Example of Superfluid Sentinel logs for Polygon Mainnet RPC


## CloudWatch: Alarms and Notifications

I also created a SNS (Amazon Simple Notification Service) topic to deliver notifications via e-mail. For it, we also have Metrics Alarms in order to compare metrics (on our case i created a Alarm to verify if we do have at least 1 running instance of Sentinel's image on our ECS Cluster) and generate data.

![](https://i.imgur.com/zrE3VY3.png)
> CloudWatch Alarm 

And here we have an example of the sent e-mail:

![](https://i.imgur.com/R4DZtgR.png)
> Example of the AWS e-mail when our Sentinel's image is not "Running" into our ECS Cluster


## Application LoadBalancer (Optional - not included by default)

This project also have a LoadBalancer module (in which is commented on terraform/modules/ecs/loadbalancer.tf)
