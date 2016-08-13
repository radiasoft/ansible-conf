# Ansible Deployment

This repository contains [Ansible](https://www.ansible.com) [playbooks](http://docs.ansible.com/ansible/playbooks.html), to provision radiasoft's servers.

## Setup

### Fetching the repo

This repository has git submodules associated, when cloning, don't forget to get the related submodules:

    > git submodule update --init
    
### Enviroment setup

This repository is [autoenv](https://github.com/kennethreitz/autoenv) enabled; it contains `.env` scripts that will setup the enviroment automatically for you, depending on the context of operation.

#### Requirements

* Python 2.7
* [Virtualenv](https://virtualenv.pypa.io/en/stable/) (expected to be found in the `PATH` as `virtualenv-2.7`)
* [Terraform](https://terraform.io)

## Enviroment

### Main 
The `main` environment is activated by setting the root directory of the repo as the working directory. It configures the enviroment for regular ansible usage. For more details see [`MAIN.md`](MAIN.md).

### Vagrant
The `vagrant` environment is activated by setting the `vagrant/` directory as the working directory. It configures the enviroment to use vagrant as deployment target. It is used mainly for development. For more details see [`vagrant/README.md`](vagrant/README.md).

### Terraform

The `terraform` enviroment is activated by setting the `terraform/` directory as the working directory. It is used to setup the AWS infrastructure, that will be configured by Ansible. For more details see [`terraform/README.md`](terraform/README.md).
