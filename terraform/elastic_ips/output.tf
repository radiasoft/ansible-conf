# Terraform requires a workaround to output maps
# https://github.com/hashicorp/terraform/issues/3690
output "jupyterhub_eip_id" {
    value = "${
        map(
            "alpha", "${aws_eip.alpha-jupyterhub.id}"
        )
    }"
}

output "jupyterhub_eip_ip" {
    value = "${
        map(
            "alpha", "${aws_eip.alpha-jupyterhub.public_ip}"
        )
    }"
}
