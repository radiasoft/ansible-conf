variable "aws_access_key" {}

variable "aws_secret_key" {}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "us-east-1"
}

resource "aws_instance" "jenkins" {
    ami           = "ami-3a468a57"
    instance_type = "t2.micro"
    key_name      = "${aws_key_pair.ansible.key_name}"
    vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
}

resource "aws_eip_association" "jenkins" {
    instance_id = "${aws_instance.jenkins.id}"
    allocation_id = "eipalloc-d3c263ef"
}

resource "aws_security_group" "allow_ssh" {
    name = "allow_ssh"
    description = "All inbound SSH traffic"

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_key_pair" "ansible" {
    key_name = "ansible-key"
    public_key = "${file("../ssh/id_rsa.pub")}"
}
