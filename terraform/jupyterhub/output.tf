output "bastion_ip" {
    value = "${module.bastion.bastion_public_ip}"
}

output "ansible_inventory" {
    value = "${data.template_file.ansible_inventory.rendered}"
}

