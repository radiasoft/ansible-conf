#!/bin/bash

source "$(dirname $0)/common.sh"

SSH_CLEANUP=("vagrant*" "known_hosts")

function cleanup_files {
    for filename in ${SSH_CLEANUP[*]}; do
        local P="$SSH_DIR/$filename"
        ls $P > /dev/null 2>&1 && rm $P || true
    done
}

cleanup_files
