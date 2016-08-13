# Vagrant

## Setup

### Requirements

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [vagrant-triggers plugin](https://github.com/emyl/vagrant-triggers)
* Zeroconf:
 * [Avahi](http://www.avahi.org) for Linux
 * Bonjour for OSX

### Ansible

#### Config file

The `vagrant` enviroment sets the ansible [config](http://docs.ansible.com/ansible/intro_configuration.html) to be `vagrant/ansible_vagrant.cfg`. 

#### Inventory

The config file sets the ansible [inventory](http://docs.ansible.com/ansible/intro_inventory.html) to be `vagrant/vagrant_hosts`.

## Working with the dev enviroment

Our dev enviroment assumes that all executions use `vagrant/` as the working directory. 

```
> cd vagrant
# Spin up a Vagrant instance
vagrant> vagrant up jenkins
# Deploy with Ansible
vagrant> ansible-playbook ../radia.yml
# Bring down the Vagrant instance 
vagrant> vagrant destroy -f jenkins
```
