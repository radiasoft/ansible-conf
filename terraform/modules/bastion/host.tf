resource "aws_instance" "bastion" {
    ami           = "${var.ami_id}"
    instance_type = "t2.nano"
    key_name      = "${var.ssh_key_name}"
    subnet_id     = "${aws_subnet.bastion.id}"
    
    associate_public_ip_address = true
    
    depends_on = ["aws_internet_gateway.bastion"]  

    vpc_security_group_ids = [
        "${aws_security_group.bastion.id}",
    ]
}
