output "jupyterhub_ip" {
    value = "${aws_instance.jupyterhub.public_ip}"
}

output "jupyterhub_nfs_ip" {
    value = "${aws_instance.jupyterhub_nfs.public_ip}"
}

output "ansible_inventory" {
    value = "${data.template_file.ansible_inventory.rendered}"
}
