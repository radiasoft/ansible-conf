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

variable "private_domain" {
    default = "internal.radiasoft"
}
