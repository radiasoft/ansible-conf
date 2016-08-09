variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
    default = "us-east-1"
}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
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
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDLeMp/OhUrC1HIoAFEbLao/RGoyk/OKaK9IxWyVY0L4+tvP5mq5Kpewt0BifzwV25Qal1FPLKFS3yG4kq2WsbZfqud+f42lLjNSPMEpmnMbmi94ce3OVWMn1Rf53/k/Z+4QQuTw9Uv2FGiLD3LzzFezyIPadGQ71HzwY0ZQYCpI9N4WVr/gDhc6SlFTCiBVROD1pr1hV4w9flEeQbG/L+/opvUO/ceggEgiYfr1RWs+EQ0iykedatN85pYs2AJfDfFWwgZWt9Jj9b1A/gnP5NzppUUp8NsLwftDazNFqpdL8TCU8S5pSCeIdiFgQmqLGWEb5Q/4Vl+j0UYuK0RnVQRd/m4yazrXAMz9AMhK/LD5YHUAg3aDWIUYiSuCaVCLqj2kdviYHPIQ+alLLWzEKLGUBhxpdhXqwMXrZISChAmJ5pNA4mN6wP1awYEIK35WoJWZ/En92s2a9vNhXtzui09vMuLqJsMUTzsVlDuS8Uczyv9s2vlLcchx/+JpqCzYQ9CY0i0TtooXiBpZ7XbzBCnE8e3Tf5v5LMEPtsg6KmwZvOyzdhi68nr22KZyHadEbkS2j085TYKH8Jg0Ti4GuNZtxlRCn2+lYK/XxrsK8LVWrbomfWZeEs/qtXKGBZg3GruFI9hc5ffr/uLU6J8H8P8iOaIJ7MUCEIfFqhMzAIl7Q== elventear@dolguldur.lan"
}
