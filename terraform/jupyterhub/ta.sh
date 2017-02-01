#!/bin/bash

set -e -u -o pipefail

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$BASE_DIR/../.."

pushd $BASE_DIR > /dev/null

terraform apply 
ssh-keyscan $(terraform output jupyterhub_ip) >> "$ROOT_DIR/ssh/known_hosts"
ssh-keyscan $(terraform output jupyterhub_nfs_ip) >> "$ROOT_DIR/ssh/known_hosts"
terraform output ansible_inventory > "$ROOT_DIR/inventory/00-jupyterhub_alpha.auto"

popd > /dev/null
