module "bastion" {
    ami_id         = "${lookup(var.amis, var.aws_region)}"
    bastion_subnet = "${var.bastion_subnet}"
    source         = "../modules/bastion"
    ssh_key_name   = "${aws_key_pair.bastion.key_name}"
    vpc_id         = "${aws_vpc.default.id}"
}
