resource "aws_route53_zone" "private" {
    name   = "${var.private_domain}"
    vpc_id = "${aws_vpc.default.id}"
}
