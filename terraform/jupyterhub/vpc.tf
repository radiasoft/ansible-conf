resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_internet_gateway" "public" {
    vpc_id = "${aws_vpc.default.id}"
}


resource "aws_nat_gateway" "private" {
    allocation_id = "${aws_eip.nat.id}"
    subnet_id     = "${aws_subnet.public.id}"
}

resource "aws_subnet" "public" {
    vpc_id     = "${aws_vpc.default.id}"
    cidr_block = "${var.public_subnet}"
}

resource "aws_subnet" "private" {
    vpc_id     = "${aws_vpc.default.id}"
    cidr_block = "${var.private_subnet}"
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.public.id}"
    }
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.private.id}"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id      = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}

resource "aws_route_table_association" "private" {
    subnet_id      = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"
}

resource "aws_security_group" "jupyterhub_nfs" {
    vpc_id      = "${aws_vpc.default.id}"
    name        = "jupyterhub_nfs"
    
    ingress {
        from_port = 80
        protocol  = "tcp"
        to_port   = 80

        cidr_blocks = ["0.0.0.0/0"]
    }
   
    ingress {
        from_port = 443
        protocol  = "tcp"
        to_port   = 443

        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 111 
        protocol  = "udp"
        to_port   = 111

        cidr_blocks = [
           "${var.public_subnet}",
        ]
    }

    ingress {
        from_port = 111 
        protocol  = "tcp"
        to_port   = 111

        cidr_blocks = [
           "${var.public_subnet}",
        ]
    }
    
    ingress {
        from_port = 2049
        protocol  = "udp"
        to_port   = 2049

        cidr_blocks = [
           "${var.public_subnet}",
        ]
    }

    ingress {
        from_port = 2049
        protocol  = "tcp"
        to_port   = 2049

        cidr_blocks = [
           "${var.public_subnet}",
        ]
    }
    
    ingress {
        from_port = 22
        protocol  = "tcp"
        to_port   = 22

        cidr_blocks = [
            "${var.bastion_subnet}",
        ]
    }
    
    ingress {
        from_port = 8
        protocol  = "icmp"
        to_port   = 0

        cidr_blocks = [
            "${var.bastion_subnet}",
            "${var.public_subnet}",
        ]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "jupyterhub" {
    vpc_id      = "${aws_vpc.default.id}"
    name        = "jupyterhub"
    
    ingress {
        from_port = 22
        protocol  = "tcp"
        to_port   = 22

        cidr_blocks = [
            "${var.bastion_subnet}",
        ]
    }
    
    ingress {
        from_port = 8000
        protocol  = "tcp"
        to_port   = 8000

        cidr_blocks = [
            "${var.private_subnet}",
        ]
    }
    
    ingress {
        from_port = 8
        protocol  = "icmp"
        to_port   = 0

        cidr_blocks = [
            "${var.bastion_subnet}",
            "${var.private_subnet}",
        ]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
}
