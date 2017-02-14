resource "aws_instance" "jupyterhub" {
    ami           = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.micro"
    key_name      = "${aws_key_pair.provision.key_name}"
    subnet_id     = "${aws_subnet.private.id}"
    
    root_block_device {
        iops        = 150 
        volume_size = 50 
        volume_type = "gp2"
    }

    vpc_security_group_ids = [
        "${aws_security_group.jupyterhub.id}",
    ]
}

resource "aws_route53_record" "jupyterhub_private" {
    name    = "jupyterhub.${var.private_domain}"
    records = ["${aws_instance.jupyterhub.private_ip}"]
    ttl     = "60"
    type    = "A"
    zone_id = "${aws_route53_zone.private.zone_id}"
}
