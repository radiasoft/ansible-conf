resource "aws_security_group" "bastion" {
    vpc_id      = "${aws_vpc.default.id}"
    name        = "bastion"
    description = "bastion server security group"
    
    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 8
        to_port   = 0
        protocol  = "icmp"

        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"

        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "bastion"
    }
}

resource "aws_instance" "bastion" {
    ami           = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.nano"
    subnet_id     = "${aws_subnet.public.id}"
    key_name      = "${aws_key_pair.sirepo.key_name}"
    
    associate_public_ip_address = true
    vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
    depends_on                  = ["aws_internet_gateway.default"]  

    tags {
        Name = "bastion"
    }
}
