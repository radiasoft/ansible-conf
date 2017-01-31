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
    key_name      = "${aws_key_pair.ansible.key_name}"
    subnet_id     = "${aws_subnet.public.id}"
    
    root_block_device {
        iops        = 100
        volume_size = 50 
        volume_type = "gp2"
    }

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

resource "aws_route53_record" "jupyterhub_private" {
    name    = "jupyterhub.${var.private_domain}"
    records = ["${aws_instance.jupyterhub.private_ip}"]
    ttl     = "60"
    type    = "A"
    zone_id = "${aws_route53_zone.private.zone_id}"
}

resource "aws_eip_association" "jupyterhub" {
    instance_id = "${aws_instance.jupyterhub.id}"
    allocation_id = "${data.terraform_remote_state.elastic_ips.jupyterhub_eip_id["${var.rs_channel}"]}"
}
