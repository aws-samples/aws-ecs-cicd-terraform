# Cloud Bootstrap sample project

**Scenario:** You want to get bootstrap a new software project as fast as possible. Using Terraform, you bootstrap all the available AWS services for CI/CD. Once your project is built and packaged, you deploy it into an AWS ECS cluster.
Boom! Your project is up and running and you can now enter your incremental software development cycle.

This project demonstrates just that: Bootstrapping a 'as-simple-as-possible' Kotlin-powered Spring Boot project in the AWS cloud using Terraform and AWS CI/CD build tools. Technologies/AWS Services used:

- Spring Boot (Kotlin)
- Docker
- AWS ECS/Fargate
- AWS CodeCommit/CodeBuild/CodeDeploy/CodePipeline
- Hashicorp Terraform

This sample was built upon Amazon's excellent [ECS/Fargate/Terraform Lab](https://devops-ecs-fargate.workshop.aws/en/).

## Initial Setup

The following steps are required to run this sample.

### Configuring the AWS CLI

Configure the AWS CLI to match the desired region:

```bash
aws configure
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: eu-central-1
Default output format [None]: 
```

### Edit terraform variables

```bash
cd terraform
```

Edit `terraform.tfvars`, leave the `aws_profile` as `"default"`, and set `aws_region` to the correct value for your environment.

### Build

Initialise Terraform:

```bash
terraform init
```

Build the infrastructure and pipeline using terraform:

```bash
terraform apply
```

Terraform will display an action plan. When asked whether you want to proceed with the actions, enter `yes`.

Wait for Terraform to complete the build before proceeding. It will take few minutes to complete “terraform apply” 

### Explore the stack you have built

Once the build is complete, you can explore your environment using the AWS console:
- View the ALB using the [Amazon EC2 console](https://console.aws.amazon.com/ec2).
- View the ECS cluster using the [Amazon ECS console](https://console.aws.amazon.com/ecs).
- View the ECR repo using the [Amazon ECR console](https://console.aws.amazon.com/ecr).
- View the CodeCommit repo using the [AWS CodeCommit console](https://console.aws.amazon.com/codecommit).
- View the CodeBuild project using the [AWS CodeBuild console](https://console.aws.amazon.com/codebuild).
- View the pipeline using the [AWS CodePipeline console](https://console.aws.amazon.com/codepipeline).

Note that your pipeline starts in a failed state. That is because there is no code to build in the CodeCommit repo! In the next step you will push the cloud bootstrap app into the repo to trigger the pipeline.

## Deploying the sample application

You will now use git to push the cloud bootstrap application through the pipeline.

### Set up a local git repo for the cloud bootstrap application

Start by switching to the `cloud-bootstrap-app` directory:

```bash
cd ../cloud-bootstrap-app
```
Set up your git username and email address:

```bash
git config --global user.name "Your Name"
git config --global user.email you@example.com
```

Now create a local git repo for cloud bootstrap app as follows:

```bash
git init
git add .
git commit -m "Initial commit"
```

### Set up the remote CodeCommit repo

An AWS CodeCommit repo was built as part of the pipeline you created. You will now set this up as a remote repo for your local cloud bootstrap repo.

For authentication purposes, you can use the AWS IAM git credential helper to generate git credentials based on your IAM role permissions. Run:

```bash
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
```

From the output of the Terraform build, note the Terraform output `source_repo_clone_url_http`.

```bash
cd ../terraform
export tf_source_repo_clone_url_http=$(terraform output source_repo_clone_url_http)
```

Set this up as a remote for your git repo as follows:

```bash
cd ../cloud-bootstrap-app
git remote add origin $tf_source_repo_clone_url_http
git remote -v
```

You should see something like:

```bash
origin  https://git-codecommit.eu-central-1.amazonaws.com/v1/repos/cloud-bootstrap-app (fetch)
origin  https://git-codecommit.eu-central-1.amazonaws.com/v1/repos/cloud-bootstrap-app (push)
```

### Triggering the pipeline

To trigger the pipeline, push the master branch to the remote as follows:

```bash
git push -u origin master
```

The pipeline will pull the code, build the docker image, push it to ECR, and deploy it to your ECS cluster. This will take a few minutes.
You can monitor the pipeline in the [AWS CodePipeline console](https://console.aws.amazon.com/codepipeline).


### Testing the application

From the output of the Terraform build, note the Terraform output `alb_address`.

```bash
cd ../terraform
export tf_alb_address=$(terraform output alb_address)
echo $tf_alb_address
```

Use this in your browser to access the application (perform a GET request against the `/mountains` resource).

### Pushing a change through the pipeline and re-testing

The pipeline can now be used to deploy any changes to the application.

You can try this out by e.g. adding a mountain in the `MountainsController` class.

```bash
git add .
git commit -m "Add a mountain"
```

Push the change to trigger pipeline:

```bash
git push origin master
```

As before, you can use the console to observe the progression of the change through the pipeline.

## Cleanup

Make sure that you remember to tear down the stack when finshed to avoid unnecessary charges. You can free up resources as follows:

```
cd ../terraform
terraform destroy
```

When prompted enter `yes` to allow the stack termination to proceed.

Once complete, note that you will have to manually empty and delete the S3 bucket used by the pipeline.
