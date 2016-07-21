#!/bin/bash

set -x -e -u -o pipefail

TRAVIS_USER=$1

# http://linuxsimba.com/vagrant-libvirt-install
apt-get -qq update 
apt-get -y install jq curl qemu-kvm libvirt-bin libvirt-dev htop tmux libxslt-dev libxml2-dev libvirt-dev zlib1g-dev ruby-dev  qemu-utils libvirt-dev realpath python-virtualenv build-essential python-dev
# https://github.com/mitchellh/vagrant-installers/issues/12
#LATEST_VAGRANT=$(curl -s https://releases.hashicorp.com/vagrant/index.json | jq --raw-output '.versions | to_entries | max_by(.key) | .value.builds | .[] | select(.arch=="x86_64") | select(.os=="debian") | .url ')
# https://github.com/mitchellh/vagrant/issues/7610
LATEST_VAGRANT=https://releases.hashicorp.com/vagrant/1.8.4/vagrant_1.8.4_x86_64.deb
wget -q $LATEST_VAGRANT -O /tmp/vagrant.deb && dpkg -i /tmp/vagrant.deb; 
sudo adduser $TRAVIS_USER libvirtd

test -f /usr/bin/virtualenv-2.7 || ln -s /usr/bin/virtualenv /usr/bin/virtualenv-2.7
