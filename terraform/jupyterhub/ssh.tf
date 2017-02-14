resource "aws_key_pair" "bastion" {
    key_name = "ansible-bastion-key"
    public_key = "${file("${var.bastion_ssh_key}.pub")}"
}

resource "aws_key_pair" "provision" {
    key_name = "ansible-provision-key"
    public_key = "${file("${var.provision_ssh_key}.pub")}"
}
