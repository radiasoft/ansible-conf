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

resource "aws_eip_association" "bastion" {
    instance_id = "${aws_instance.bastion.id}"
    allocation_id = "${lookup(var.bastion_eip, var.aws_region)}"
}

resource "aws_instance" "bastion" {
    ami           = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.nano"
    subnet_id     = "${aws_subnet.public.id}"
    key_name      = "${aws_key_pair.sirepo.key_name}"
    private_ip    = "${cidrhost("${var.public_subnet}", 5)}" 
    
    vpc_security_group_ids      = ["${aws_security_group.bastion.id}"]
    depends_on                  = ["aws_internet_gateway.default"]  

    connection {
        user        = "fedora"
        host        = "${self.public_ip}"
        agent       = false
        private_key = "${file("${var.ssh_private_key}")}"
    }
    
    provisioner "remote-exec" {
        inline = [
            "/usr/bin/sudo /usr/bin/dnf -y install htop nc tcpdump nmap tcping"
        ]
    }

    tags {
        Name = "bastion"
    }
}
