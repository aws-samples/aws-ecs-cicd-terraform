# Deploy petclinic application using the pipeline
Time Estimate: 15 - 20 minutes  

??? info "What is AWS CodePipeline?"
    AWS CodePipeline is a fully managed continuous delivery service that helps you automate your release pipelines for fast and reliable application and infrastructure updates. CodePipeline automates the build, test, and deploy phases of your release process every time there is a code change, based on the release model you define. This enables you to rapidly and reliably deliver features and updates. You can easily integrate AWS CodePipeline with third-party services such as GitHub or with your own custom plugin. With AWS CodePipeline, you only pay for what you use. There are no upfront fees or long-term commitments.

You will now use git to push the petclinic application through the pipeline.


### Set up a local git repo for the petclinic application

Start by switching to the `petclinic` directory:

```bash
cd ../petclinic
```

Set up your git username and email address:

```bash
git config --global user.name "Your Name"
git config --global user.email you@example.com
```

Now ceate a local git repo for petclinic as follows:

```bash
git init
git add .
git commit -m "Baseline commit"
```

### Set up the remote CodeCommit repo

An AWS CodeCommit repo was built as part of the pipeline you created. You will now set this up as a remote repo for your local petclinic repo.

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
cd ../petclinic
git remote add origin $tf_source_repo_clone_url_http
git remote -v
```

You should see something like:

```bash
origin  https://git-codecommit.eu-west-2.amazonaws.com/v1/repos/petclinic (fetch)
origin  https://git-codecommit.eu-west-2.amazonaws.com/v1/repos/petclinic (push)
```
