variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default     = "us-east-1"
}

variable "amis" {
    description = "Fedora 23 Cloud Base AMIs by region"
    
    default {
        us-east-1 = "ami-3a468a57" 
    }
}

variable "nat_eip" {
    description = "Elatic IP allocation id per region for worker's NAT endpoint"

    default {
        us-east-1 = "eipalloc-d9bdc9e6"
    }
}

variable "bastion_eip" {
    description = "Elatic IP allocation id per region for Bastion servers"

    default {
        us-east-1 = "eipalloc-89bacbb6"
    }
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default     = "10.14.0.0/16"
}

variable "private_subnet" {
    description = "CIDR for the Sirepo Workers Subnet"
    default     = "10.14.2.0/24"
}
    
variable "public_subnet" {
    description = "CIDR for the Bastion Subnet"
    default     = "10.14.1.0/24"
}

variable "worker_count" {
    description = "Number of Workers to create"
    default     = 1
}

variable "ssh_private_key" {
    description = "Path to SSH private key to use, expect to `.pub` public key alongside"
    default     = "id_rsa"
}
