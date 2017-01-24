resource "aws_key_pair" "ansible" {
    key_name = "ansible-key"
    public_key = "${file("${var.ansible_ssh_key}.pub")}"
}
