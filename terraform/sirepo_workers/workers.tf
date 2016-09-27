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
    private_ip    = "${cidrhost("${var.private_subnet}", 5 + count.index)}" 
    
    vpc_security_group_ids = ["${aws_security_group.worker.id}"]
    depends_on             = ["aws_internet_gateway.default", "aws_nat_gateway.default"] 

    root_block_device {
        volume_type = "gp2"
        volume_size = 30
        iops        = 100
    }

    connection {
        user        = "root"
        host        = "${self.private_ip}"
        agent       = false
        private_key = "${file("${var.ssh_private_key}")}"

        bastion_user = "fedora"
        bastion_host = "${aws_instance.bastion.public_ip}"
    }

    provisioner "remote-exec" {
        connection {
            user        = "fedora"
            host        = "${aws_instance.bastion.public_ip}"
            agent       = false
            private_key = "${file("${var.ssh_private_key}")}"
        
            bastion_user = ""
            bastion_host = ""
        }

        inline = [
            "while ! /usr/bin/tcping -q -t 1 ${self.private_ip} 22; do sleep 5; done",
            "/usr/bin/ssh-keygen -R ${self.private_ip}",
            "/usr/bin/ssh-keyscan -H ${self.private_ip} >> ~/.ssh/known_hosts",
        ]
    }

    provisioner "remote-exec" {
        connection {
            user = "fedora"
        }

        inline = [
            "/usr/bin/sudo rm /root/.ssh/authorized_keys",
            "/usr/bin/sudo /bin/bash -c \"echo '${file("${var.ssh_private_key}.pub")}' > /root/.ssh/authorized_keys\"",
            "/usr/bin/sudo /usr/bin/chmod 0600 /root/.ssh/authorized_keys"
        ]
    }

    provisioner "remote-exec" {
        inline = [
            "/usr/bin/pkill -u 1000 -9", 
            "/sbin/groupmod -n vagrant fedora",
            "/sbin/usermod -l vagrant fedora",
            "/sbin/usermod -m -d /home/vagrant vagrant",
        ]
    }

    provisioner "file" {
        source      = "scripts/worker_provision.sh"
        destination = "/tmp/worker_provision.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "/bin/bash /tmp/worker_provision.sh"
        ]
    }

    tags {
        Name = "worker-${count.index}"
    }
}
