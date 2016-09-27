resource "aws_security_group" "worker" {
    vpc_id      = "${var.vpc_id}"
    name        = "${var.channel}-worker"
    description = "worker servers security group"

    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"
        
        security_groups = [
            "${var.bastion_security_group_id}"
        ]
    }

    ingress {
        from_port = 8
        to_port   = 0
        protocol  = "icmp"
        
        security_groups = [
            "${var.bastion_security_group_id}"
        ]
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"

        cidr_blocks = ["0.0.0.0/0"]
    }

    tags {
        Name = "${var.channel}-worker"
    }
}

resource "aws_instance" "worker" {
    ami           = "${var.worker_ami_id}"
    instance_type = "${var.worker_instance_type}"
    subnet_id     = "${aws_subnet.private.id}"
    key_name      = "${var.ssh_key_name}"
    count         = "${var.worker_count}"
    private_ip    = "${cidrhost("${var.subnet_cidr}", 5 + count.index)}" 
    
    vpc_security_group_ids = ["${aws_security_group.worker.id}"]

    root_block_device {
        volume_type = "gp2"
        volume_size = 10
        iops        = 100
    }

    connection {
        user        = "root"
        host        = "${self.private_ip}"
        agent       = false
        private_key = "${file(var.ssh_private_key)}"

        bastion_user = "fedora"
        bastion_host = "${var.bastion_public_ip}"
    }

    provisioner "remote-exec" {
        connection {
            user        = "fedora"
            host        = "${var.bastion_public_ip}"
            agent       = false
            private_key = "${file(var.ssh_private_key)}"
        
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

/*
    provisioner "file" {
        source      = "scripts/worker_provision.sh"
        destination = "/tmp/worker_provision.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "/bin/bash /tmp/worker_provision.sh"
        ]
    }
*/

    tags {
        Name = "${var.channel}-worker-${count.index}"
    }
}
