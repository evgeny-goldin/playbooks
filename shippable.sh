#!/bin/bash

set -x

./packer/ansible/install-ansible.sh
cd playbooks
ansible-playbook packer-ubuntu.yml -c local -i "127.0.0.1,”
