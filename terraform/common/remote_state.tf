data "terraform_remote_state" "elastic_ips" {
    backend = "local"
    config {
        path = "${path.module}/../elastic_ips/terraform.tfstate"
    }
}
