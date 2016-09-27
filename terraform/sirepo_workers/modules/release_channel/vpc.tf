resource "aws_subnet" "private" {
    vpc_id     = "${var.vpc_id}"
    cidr_block = "${var.subnet_cidr}"

    tags {
        Name = "${var.channel}-private"
    }
}

resource "aws_route_table" "private" {
    vpc_id = "${var.vpc_id}"

    route {
        nat_gateway_id = "${var.nat_gateway_id}"
        cidr_block     = "0.0.0.0/0"
    }
    
    tags {
        Name = "${var.channel}-private"
    }
}

resource "aws_route_table_association" "private" {
    subnet_id      = "${aws_subnet.private.id}"
    route_table_id = "${aws_route_table.private.id}"
}
