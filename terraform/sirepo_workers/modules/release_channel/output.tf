output "worker_ips" {
    value = ["${aws_instance.worker.*.private_ip}"]
} 
