#!/bin/bash

set -x

./packer/ansible/install-ansible.sh

ansible-playbook playbooks/asgard-ubuntu.yml  -c local
ansible-playbook playbooks/jenkins-ubuntu.yml -c local
ansible-playbook playbooks/mysql-ubuntu.yml   -c local
ansible-playbook playbooks/packer-ubuntu.yml  -c local
