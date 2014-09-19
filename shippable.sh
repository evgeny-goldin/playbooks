#!/bin/bash

set -e
set -x

./docker/ansible/install-ansible.sh
# ansible-playbook playbooks/packer-ubuntu.yml -c local

# ---------------
# Ansible
# ---------------

# ansible-playbook playbooks/asgard-ubuntu.yml  -c local -e "periodic=true start_service=False AWS_ACCOUNT_ID=N AWS_ACCESS_KEY_ID=N AWS_SECRET_ACCESS_KEY=N"
# ansible-playbook playbooks/jenkins-ubuntu.yml -c local -e "periodic=true start_service=False"
# ansible-playbook playbooks/mysql-ubuntu.yml   -c local -e "periodic=true start_service=False"

# ---------------
# Docker
# ---------------

# for box in ansible:1.7.1; do
#   name=$(echo $box | sed -r 's/:.+//')
#   cp "docker/$name/Dockerfile" .
#   docker build --rm --no-cache -t "evgenyg/$box" .
# done
