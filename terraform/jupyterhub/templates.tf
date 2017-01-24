data "template_file" "ansible_inventory" {
    template = "${file("inventory.tpl")}"

    vars {
        jupyterhub_ip = "${aws_instance.jupyterhub.public_ip}"
        jupyterhub_nfs_ip = "${aws_instance.jupyterhub_nfs.public_ip}"
        channel = "${var.rs_channel}"
    }
}
