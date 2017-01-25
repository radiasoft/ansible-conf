resource "aws_security_group" "jupyterhub" {
    vpc_id      = "${aws_vpc.default.id}"
    name        = "jupyterhub"
    
    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 8000
        to_port   = 8000
        protocol  = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 443
        to_port   = 443
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
}

resource "aws_instance" "jupyterhub" {
    ami           = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.micro"
    subnet_id     = "${aws_subnet.public.id}"
    key_name      = "${aws_key_pair.ansible.key_name}"

    connection {
        user        = "centos"
        agent       = false
        private_key = "${file("${var.ansible_ssh_key}")}"
    }

    provisioner "remote-exec" {
        inline = [
            "/usr/bin/sudo -i /bin/mkdir -p /etc/ansible/facts.d",
            "/usr/bin/sudo -i /bin/bash  -c \"echo '\"ec2\"' > /etc/ansible/facts.d/deploy_env.fact\"",
            "/usr/bin/sudo -i /bin/mv /home/centos/.ssh/authorized_keys /root/.ssh",
            "/usr/bin/sudo -i /bin/chown -R root:root /root/.ssh",
            "/usr/bin/sudo -i /usr/sbin/userdel -f -r centos",
        ]
    }

    associate_public_ip_address = true
    vpc_security_group_ids      = [
        "${aws_security_group.internal.id}",
        "${aws_security_group.jupyterhub.id}",
    ]
    depends_on                  = ["aws_internet_gateway.default"]  
}
