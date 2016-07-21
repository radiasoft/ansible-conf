#!/bin/bash

set -x -e -u -o pipefail

cd vagrant

source .env

sudo -E su $USER -c ' vagrant up --provider=libvirt'

ansible-playbook ../radia.yml

