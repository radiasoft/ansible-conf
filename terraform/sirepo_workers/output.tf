output "bastion_ip" {
    value = "${aws_instance.bastion.public_ip}"
}

output "worker_ips" {
    value = ["${aws_instance.worker.*.private_ip}"]
}
