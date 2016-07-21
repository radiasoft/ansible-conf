#!/bin/bash

source "$(dirname $0)/common.sh"

SSH_CLEANUP=("vagrant*" "known_hosts")

function cleanup_files {
    if [[ ! "$(ls -A .vagrant/machines/*/virtualbox)" ]]; then
        for filename in ${SSH_CLEANUP[*]}; do
            local P="$SSH_DIR/$filename"
            ls $P > /dev/null 2>&1 && rm $P || true
        done
        echo "Removed SSH keys under: $SSH_DIR"
    fi
}

cleanup_files
