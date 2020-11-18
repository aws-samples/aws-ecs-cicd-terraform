# Tearing down the stack

When finished, you can free up resources as follows:

```
cd ../terraform
terraform destroy
```

When prompted enter `yes` to allow the stack termination to proceed.

Once complete, note that you will have to manually empty and delete the S3 bucket used by the pipeline.