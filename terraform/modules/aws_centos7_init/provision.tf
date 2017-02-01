resource "null_resource" "provision" {
    triggers {
        instance_id = "${var.instance_id}"
    }

    connection {
        agent       = false
        host        = "${var.host}" 
        private_key = "${var.ssh_key}"
        user        = "centos"
    }

    provisioner "file" {
        source = "${path.module}/files/init_script.sh"
        destination = "/tmp/init_script.sh"
    }

    provisioner "remote-exec" {
        inline = [
            "/usr/bin/sudo -i /bin/bash /tmp/init_script.sh"
        ]
    }
}
