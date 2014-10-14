#!/bin/sh

set -x

sed -i 's/archive\.ubuntu\.com/se.archive.ubuntu.com/' /etc/apt/sources.list
sudo apt-get update  -y
sudo apt-get upgrade -y
sudo apt-get install -y vim python-pip python-dev
sudo pip install --upgrade ansible

sudo mkdir -p /etc/ansible/
echo 'localhost' | sudo tee --append /etc/ansible/hosts

ansible          --version
ansible-playbook --version
ansible localhost -c local -m setup
