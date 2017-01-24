resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

resource "aws_subnet" "public" {
    vpc_id     = "${aws_vpc.default.id}"
    cidr_block = "${var.public_subnet}"
}

resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        gateway_id = "${aws_internet_gateway.default.id}"
        cidr_block = "0.0.0.0/0"
    }
}

resource "aws_route_table_association" "public" {
    subnet_id      = "${aws_subnet.public.id}"
    route_table_id = "${aws_route_table.public.id}"
}

