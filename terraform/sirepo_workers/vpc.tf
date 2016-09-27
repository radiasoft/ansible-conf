resource "aws_vpc" "default" {
    cidr_block           = "${var.vpc_cidr}"
    enable_dns_hostnames = true

    lifecycle {
        create_before_destroy = true
    }

    tags {
        Name = "sirepo"
    }
}

# Subnet Public

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

resource "aws_subnet" "public" {
    vpc_id     = "${aws_vpc.default.id}"
    cidr_block = "${var.public_subnet}"

    tags {
        Name = "public"
    }
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        gateway_id = "${aws_internet_gateway.default.id}"
        cidr_block = "0.0.0.0/0"
    }
    
    tags {
        Name = "public"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id      = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}

# Subnet Private

resource "aws_nat_gateway" "default" {
    allocation_id = "${lookup(var.nat_eip, var.aws_region)}"
    subnet_id     = "${aws_subnet.public.id}"
}

resource "aws_subnet" "private" {
    vpc_id     = "${aws_vpc.default.id}"
    cidr_block = "${var.private_subnet}"

    tags {
        Name = "private"
    }
}

resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        nat_gateway_id = "${aws_nat_gateway.default.id}"
        cidr_block     = "0.0.0.0/0"
    }
    
    tags {
        Name = "private"
    }
}

resource "aws_route_table_association" "private" {
    subnet_id      = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"
}
