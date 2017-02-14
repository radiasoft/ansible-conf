resource "aws_security_group" "jupyterhub_nfs" {
    vpc_id      = "${aws_vpc.default.id}"
    name        = "jupyterhub_nfs"
    
    ingress {
        from_port = 22
        to_port   = 22
        protocol  = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 80
        to_port   = 80
        protocol  = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 443
        to_port   = 443
        protocol  = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 8
        to_port   = 0
        protocol  = "icmp"

        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1"

        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "jupyterhub_nfs" {
    ami           = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.nano"
    key_name      = "${aws_key_pair.provision.key_name}"
    subnet_id     = "${aws_subnet.public.id}"
    
    root_block_device {
        iops        = 100
        volume_size = 50 
        volume_type = "gp2"
    }
    
    associate_public_ip_address = true 
    
    vpc_security_group_ids = [
        "${aws_security_group.internal.id}",
        "${aws_security_group.jupyterhub_nfs.id}",
    ]

    depends_on = ["aws_internet_gateway.default"]  
}

module "jupyterhub_nfs_provision" {
    host        = "${aws_instance.jupyterhub_nfs.public_ip}"
    instance_id = "${aws_instance.jupyterhub_nfs.id}" 
    source      = "../modules/aws_centos7_init"
    ssh_key     = "${file("${var.provision_ssh_key}")}"
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
    depends_on    = ["aws_instance.jupyterhub_nfs", "module.jupyterhub_nfs_provision"]
}
