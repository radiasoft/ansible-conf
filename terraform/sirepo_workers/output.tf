output "bastion_ip" {
    value = "${aws_eip_association.bastion.public_ip}"
}

output "nat_ip" {
    value = "${aws_eip_association.bastion.public_ip}"
}


output "worker_ips" {
    value = ["${aws_instance.worker.*.private_ip}"]
}
