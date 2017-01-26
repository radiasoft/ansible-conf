#!/bin/bash

set -e -u -o pipefail

terraform apply 
ssh-keyscan $(terraform output jupyterhub_ip) >> "$HOME/.ssh/known_hosts"
ssh-keyscan $(terraform output jupyterhub_nfs_ip) >> "$HOME/.ssh/known_hosts"
terraform output ansible_inventory > ../../inventory/00-jupyterhub_alpha.auto
