#!/bin/bash

set -x

./packer/ansible/install-ansible.sh
ansible-playbook playbooks/packer-ubuntu.yml -c local
