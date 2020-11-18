# Build the infrastructure and pipeline
Time Estimate: 10 - 15 minutes

We shall use Terraform to build the above architecture including the AWS CodePipeline.

### Set up SSM parameter for DB passwd

```bash
aws ssm put-parameter --name /database/password  --value mysqlpassword --type SecureString
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
- View the RDS database using the [Amazon RDS console](https://console.aws.amazon.com/rds).

- View the ALB using the [Amazon EC2 console](https://console.aws.amazon.com/ec2).

- View the ECS cluster using the [Amazon ECS console](https://console.aws.amazon.com/ecs).

- View the ECR repo using the [Amazon ECR console](https://console.aws.amazon.com/ecr).

- View the CodeCommit repo using the [AWS CodeCommit console](https://console.aws.amazon.com/codecommit).

- View the CodeBuild project using the [AWS CodeBuild console](https://console.aws.amazon.com/codebuild).

- View the pipeline using the [AWS CodePipeline console](https://console.aws.amazon.com/codepipeline).


Note that your pipeline starts in a failed state. That is because there is no code to build in the CodeCommit repo! In the next step you will push the petclinic app into the repo to trigger the pipeline.

