#!/bin/sh

set -x

sudo apt-get update  -y
sudo apt-get install -y vim htop wget curl git unzip python-pip python-dev
sudo pip install ansible==1.7.1

sudo mkdir -p    /etc/ansible
echo localhost > /etc/ansible/hosts

ansible          --version
ansible-playbook --version
ansible localhost -c local -m setup
