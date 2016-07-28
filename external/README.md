# About external

Currently this directory serves to link external git repositories via git *submodules*. 

## Usage

Ansible provides functionality to extended the functionality of ansible itself via plugins. These plugins can be globally installed or can be part of the playbook/role directory structure. If the plugin is available in certain [locations](http://docs.ansible.com/ansible/developing_plugins.html) within the structure, it will picked up by the ansible playbook.

The best way to reuse and not duplicate code by third parties is to referenced their repo as a git subrepo and symlink the files from those repos to the right location within our repo.

## List of currently linked submodules

* [ansible-filter-plugins](https://github.com/lxhunter/ansible-filter-plugins.git): Provides ready to use out of the box, Jinja2 filter plugins. 
* [ansible-modules-core](https://github.com/ansible/ansible-modules-core.git): dev branch of the ansible core plugins. Used for the [`systemd`](https://docs.ansible.com/ansible/systemd_module.html) plugin that has not been released yet.

