output "bastion_ip" {
    value = "${aws_eip_association.bastion.public_ip}"
}

output "nat_ip" {
    value = "${aws_eip_association.bastion.public_ip}"
}

output "alpha_ips" {
    value = "${module.alpha_channel.worker_ips}"
}

output "beta_ips" {
    value = "${module.beta_channel.worker_ips}"
}

