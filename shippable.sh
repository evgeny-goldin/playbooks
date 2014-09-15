#!/bin/bash

set -x

./packer/ansible/install-ansible.sh
ansible localhost -c local -m setup
ansible-playbook playbooks/packer-ubuntu.yml -c local
