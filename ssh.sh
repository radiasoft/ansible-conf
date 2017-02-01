#!/bin/bash

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

exec ssh -o UserKnownHostsFile="$BASE_DIR/ssh/known_hosts" -F "$BASE_DIR/ssh/config" -i "$BASE_DIR/ssh/id_rsa" $@
