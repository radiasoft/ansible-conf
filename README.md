### Ansible Deployment

This is a work in progress

#### Vagrant deployment

Ansible needs to be installed on the host machine and accessible via the `PATH` enviroment variable. For reproducibility
we include the enviroment used for development, which can be boostraped with the following recipe, from the root of the 
repo:

    > virtualenv-2.7 dev/.venv
    > source dev/.venv/bin/activate
    > pip install -r dev/requirements.txt

To launch a Vagrant instance and deploy with ansible:

    > cd dev
    > vagrant up
