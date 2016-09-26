resource "aws_key_pair" "sirepo" {
    key_name = "sirepo-key"
    public_key = "${file("id_rsa.pub")}"
}

