# Trigger the pipeline
Time Estimate: 15 - 20 minutes  

To trigger the pipeline, push the master branch to the remote as follows:

```bash
git push -u origin master
```

The pipeline will pull the code, build the docker image, push it to ECR, and deploy it to your ECS cluster. This will take a few minutes.
You can monitor the pipeline in the [AWS CodePipeline console](https://console.aws.amazon.com/codepipeline).


### Test the application

From the output of the Terraform build, note the Terraform output `alb_address`.

```bash
cd ../terraform
export tf_alb_address=$(terraform output alb_address)
echo $tf_alb_address
```

Use this in your browser to access the application.


## Push a change through the pipeline and re-test

The pipeline can now be used to deploy any changes to the application.

You can try this out by changing the welcome message as follows:

```
cd ../petclinic
vi src/main/resources/messages/messages.properties
```
Change the value for the welcome string, for example, to "Hello".

Commit the change:

```
git add .
git commit -m "Changed welcome string"
```

Push the change to trigger pipeline:

```bash
git push origin master
```

As before, you can use the console to observe the progression of the change through the pipeline. Once done, verify that the application is working with the modified welcome message.
