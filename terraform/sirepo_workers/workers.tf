resource "aws_security_group" "worker" {
    vpc_id      = "${aws_vpc.default.id}"
    name        = "worker"
    description = "worker servers security group"

    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        
        security_groups = [
            "${aws_security_group.bastion.id}"
        ]
        #cidr_blocks = ["${var.public_subnet}"]
    }

    ingress {
        from_port = 8
        to_port   = 0
        protocol  = "icmp"
        
        security_groups = [
            "${aws_security_group.bastion.id}"
        ]
        #cidr_blocks = ["${var.public_subnet}"]
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"

        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "worker"
    }
}

resource "aws_instance" "worker" {
    ami           = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.nano"
    subnet_id     = "${aws_subnet.private.id}"
    key_name      = "${aws_key_pair.sirepo.key_name}"
    count         = "${var.worker_count}"
    
    vpc_security_group_ids = ["${aws_security_group.worker.id}"]
    depends_on             = ["aws_internet_gateway.default", "aws_nat_gateway.default"]  

    tags {
        Name = "worker-${count.index}"
    }
}
