variable "bastion_ssh_key" {
    default = "../../ssh/bastion_key"
}

variable "bastion_subnet" {
    default = "10.0.1.0/24"
}

variable "deploy_env" {
    default = "ec2"
}

variable "public_subnet" {
    description = "CIDR for the public subnet"
    default = "10.0.0.0/24"
}

variable "private_domain" {
    default = "internal.radiasoft"
}

variable "provision_ssh_key" {
    default = "../../ssh/provision_key"
}

variable "rs_channel" {
    default = "alpha"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}
