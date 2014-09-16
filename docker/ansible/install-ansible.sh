#!/bin/sh

set -x

sudo apt-get update  -y
sudo apt-get install -y python-pip python-dev
sudo pip install ansible==1.7.1

echo localhost > hosts
sudo mkdir -p /etc/ansible/
sudo mv hosts /etc/ansible/

ansible          --version
ansible-playbook --version
ansible localhost -c local -m setup
