resource "aws_instance" "jupyterhub_nfs" {
    ami           = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.nano"
    key_name      = "${aws_key_pair.provision.key_name}"
    subnet_id     = "${aws_subnet.public.id}"
    
    root_block_device {
        iops        = 150 
        volume_size = 50 
        volume_type = "gp2"
    }
    
    vpc_security_group_ids = [
        "${aws_security_group.jupyterhub_nfs.id}",
    ]
}

resource "aws_route53_record" "jupyterhub_nfs_private" {
    name    = "jupyterhub_nfs.${var.private_domain}"
    records = ["${aws_instance.jupyterhub_nfs.private_ip}"]
    ttl     = "60"
    type    = "A"
    zone_id = "${aws_route53_zone.private.zone_id}"
}

resource "aws_eip_association" "jupyterhub_nfs" {
    allocation_id = "${data.terraform_remote_state.elastic_ips.jupyterhub_eip_id["${var.rs_channel}"]}"
    instance_id   = "${aws_instance.jupyterhub_nfs.id}"
    depends_on    = ["aws_instance.jupyterhub_nfs"]
}
