variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "us-east-1"
}

variable "amis" {
    description = "Fedora 23 Cloud Base AMIs by region"
    default = {
        us-east-1 = "ami-3a468a57" 
    }
}

variable "nat_eip" {
    default = {
        us-east-1 = "eipalloc-d9bdc9e6"
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "private_subnet" {
    description = "CIDR for the Sirepo Workers Subnet"
    default = "10.0.0.0/24"
}

variable "public_subnet" {
    description = "CIDR for the Bastion Subnet"
    default = "10.0.2.0/24"
}

