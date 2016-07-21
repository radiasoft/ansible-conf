#!/bin/bash

source "$(dirname $0)/common.sh"

function create_ssh_keys {
    local SSH_KEY="$SSH_DIR/vagrant"
    if [[ ! -f "$SSH_KEY" ]]; then
        echo '' | ssh-keygen -q -C "ansible vagrant" -f $SSH_KEY  
        echo "Created new SSH key: $SSH_KEY"
    fi 
}

create_ssh_keys

