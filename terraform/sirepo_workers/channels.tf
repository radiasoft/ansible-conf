module "alpha_channel" {
    channel        = "alpha"
    
    source = "./modules/release_channel"
    vpc_id         = "${aws_vpc.default.id}"
    subnet_cidr    = "${lookup(var.worker_subnet, "alpha")}"
    nat_gateway_id = "${aws_nat_gateway.default.id}"

    bastion_security_group_id = "${aws_security_group.bastion.id}"
    worker_ami_id = "${lookup(var.amis, var.aws_region)}" 
    worker_instance_type = "t2.nano"
    ssh_key_name = "${aws_key_pair.sirepo.key_name}"
    worker_count = "${var.alpha_worker_count}"
    bastion_public_ip = "${aws_instance.bastion.public_ip}"
    ssh_private_key = "${var.ssh_private_key}" 
}

module "beta_channel" {
    channel        = "beta"
    
    source = "./modules/release_channel"
    vpc_id         = "${aws_vpc.default.id}"
    subnet_cidr    = "${lookup(var.worker_subnet, "beta")}"
    nat_gateway_id = "${aws_nat_gateway.default.id}"

    bastion_security_group_id = "${aws_security_group.bastion.id}"
    worker_ami_id = "${lookup(var.amis, var.aws_region)}" 
    worker_instance_type = "t2.nano"
    ssh_key_name = "${aws_key_pair.sirepo.key_name}"
    worker_count = "${var.beta_worker_count}"
    bastion_public_ip = "${aws_instance.bastion.public_ip}"
    ssh_private_key = "${var.ssh_private_key}" 
}

