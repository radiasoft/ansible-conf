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

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet" {
    description = "CIDR for the public subnet"
    default = "10.0.0.0/24"
}

variable "ansible_ssh_key" {
    default = "../../ssh/id_rsa"
}

variable "rs_channel" {
    default = "alpha"
}
