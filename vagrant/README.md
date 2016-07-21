### Development Enviroment Setup

The dev enviroment requieres the following packages to be already available on the system:

* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Vagrant](https://www.vagrantup.com/downloads.html)
* [Python 2.7](https://www.python.org/downloads/)
* [virtualenv](https://pypi.python.org/pypi/virtualenv) for Python 2.7

#### Environment setup

The development enviroment requires additional packages and enviroment variables injected in your work enviroment. The file `vagrant/.env` is provided for such purpose. In your terminal issue the following command:

```
> source vagrant/.env
```

#### Working with the dev enviroment

Our dev enviroment assumes that all executions use `vagrant/` as the working directory. 

```
> cd vagrant
# Spin up a Vagrant instance
vagrant> vagrant up
# Deploy with Ansible
vagrant> ansible-playbook ../radia.yml
# Bring down the Vagrant instance 
```
