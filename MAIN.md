# Main

## Ansible

### Config file

In the root directory, exists [`ansible.cfg`](http://docs.ansible.com/ansible/intro_configuration.html) which customizes ansible to use directly the contents of the repo without any further customization.

#### Inventory

The config file sets the ansible [inventory](http://docs.ansible.com/ansible/intro_inventory.html) to be `hosts` located in the root directory.

#### SSH

By default, ansible will use the SSH key under `ssh/id_rsa` for authentication during deployment.

## Deployment variables

Te main most variables already setup within the repo. If it is required, they could be overloaded using regular ansible [variable precedence](http://docs.ansible.com/ansible/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable) rules. Password and similar kind of information is not hardcoded within the repo, but placed within a `secret.yml` which git is configured to ignore. To find out what needs to be configured, search for `secret.sample` within the repo, which will detail the variables that need to be configured before deployment; copy the file in the same directory as `secret.yml` and fill in the values appropriately.

## Deploying with Ansible

```
> ansible-playbook radia.yml
```
