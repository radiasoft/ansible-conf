variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
    default = "us-east-1"
}

variable "amis" {
    description = "Centos 7 AMIs by region"
    default = {
        us-east-1 = "ami-6d1c2007" 
    }
}
