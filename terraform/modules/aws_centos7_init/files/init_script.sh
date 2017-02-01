#!/bin/bash

set -e -u -o pipefail

FACT_D=/etc/ansible/facts.d

mkdir -p "$FACT_D"
echo '"ec2"' > "$FACT_D/deploy_env.fact"

/bin/mv /home/centos/.ssh/authorized_keys /root/.ssh
/bin/chown -R root: /root/.ssh
/usr/sbin/userdel -f -r centos

rm $0
