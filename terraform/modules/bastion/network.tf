resource "aws_internet_gateway" "bastion" {
    vpc_id = "${var.vpc_id}"
}

resource "aws_route_table" "bastion" {
    vpc_id = "${var.vpc_id}"

    route {
        gateway_id = "${aws_internet_gateway.bastion.id}"
        cidr_block = "0.0.0.0/0"
    }
}

resource "aws_route_table_association" "bastion" {
    subnet_id      = "${aws_subnet.bastion.id}"
    route_table_id = "${aws_route_table.bastion.id}"
}

resource "aws_security_group" "bastion" {
    vpc_id      = "${var.vpc_id}"
    name        = "bastion"
    
    ingress {
        from_port = 22
        to_port   = 22
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

resource "aws_subnet" "bastion" {
    vpc_id     = "${var.vpc_id}"
    cidr_block = "${var.bastion_subnet}"
}
