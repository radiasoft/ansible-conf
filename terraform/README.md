# Terraform

## Setup

### Requirements

[Terraform](https://terraform.io) needs to be installed and available within the `PATH` environment. 

### AWS API credentials

Terraform requires access to AWS credentials; credentials can be set via an enviroment variable. To set them via `autoenv`, set the following values in `terraform/.env.secret`: 

```
export TF_VAR_aws_access_key="<AWS_ID>"
export TF_VAR_aws_secret_key="<AWS_SECRET>"
```   
 
## Deploying AWS infrastructure

To deploy to AWS, issue the following commands:

```
> cd terraform
terraform> terraform plan
terraform> terraform apply
```   
    
