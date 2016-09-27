resource "aws_key_pair" "sirepo" {
    key_name = "sirepo-key"
    public_key = "${file("${var.ssh_private_key}.pub")}"
}

