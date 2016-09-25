# SSH

resource "aws_key_pair" "sirepo" {
    key_name = "sirepo-key"
    public_key = "${file("id_rsa.pub")}"
}

# VPC

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags {
        Name = "sirepo vpc"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

resource "aws_nat_gateway" "default" {
    allocation_id = "${lookup(var.nat_eip, var.aws_region)}"
    subnet_id = "${aws_subnet.private.id}"

    depends_on = ["aws_internet_gateway.default"]
}

# Subnet Private

resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.private_subnet}"

    tags {
        Name = "Sirepo Workers Subnet"
    }
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.default.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.default.id}"
    }

    tags {
        Name = "Sirepo Workers Subnet"
    }
}

resource "aws_route_table_association" "private" {
    subnet_id = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"
}

# Subnet Public

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.public_subnet}"

    tags {
        Name = "Sirepo Workers Subnet"
    }
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.default.id}"
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "Sirepo Workers Subnet"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}

# Bastion

resource "aws_security_group" "bastion" {
    vpc_id = "${aws_vpc.default.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "bastion" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.nano"
    subnet_id = "${aws_subnet.public.id}"
    associate_public_ip_address = true
    key_name = "${aws_key_pair.sirepo.key_name}"
    security_groups = ["${aws_security_group.bastion.id}"]

    tags {
        Name = "Bastion"
    }
}

# Worker

resource "aws_security_group" "worker" {
    vpc_id = "${aws_vpc.default.id}"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.public_subnet}"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "worker" {
    ami = "${lookup(var.amis, var.aws_region)}"
    instance_type = "t2.nano"
    subnet_id = "${aws_subnet.private.id}"
    key_name = "${aws_key_pair.sirepo.key_name}"
    security_groups = ["${aws_security_group.worker.id}"]

    tags {
        Name = "Worker"
    }
}
