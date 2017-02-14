module "bastion" {
    ami_id         = "${lookup(var.amis, var.aws_region)}"
    bastion_subnet = "${var.bastion_subnet}"
    internet_gw_id = "${aws_internet_gateway.public.id}"
    source         = "../modules/bastion"
    ssh_key_name   = "${aws_key_pair.bastion.key_name}"
    vpc_id         = "${aws_vpc.default.id}"
}

resource "aws_route53_record" "bastion_private" {
    name    = "bastion.${var.private_domain}"
    records = ["${module.bastion.bastion_private_ip}"]
    ttl     = "60"
    type    = "A"
    zone_id = "${aws_route53_zone.private.zone_id}"
}
