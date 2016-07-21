#!/bin/bash

set -x -e -u -o pipefail

vagrant plugin install vagrant-libvirt

cd vagrant

source .env

travis_wait 30 vagrant up --provider=libvirt

travis_wait 30 ansible-playbook ../radia.yml

