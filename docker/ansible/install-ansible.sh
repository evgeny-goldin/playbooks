#!/bin/sh

set -x

sed -i 's/\/archive\.ubuntu\.com\//\/ubuntu.mirror.su.se\//' /etc/apt/sources.list
sudo apt-get update  -y
sudo apt-get install -y python-pip python-dev curl
sudo pip install --upgrade ansible

sudo mkdir -p /etc/ansible/
echo 'localhost' | sudo tee --append /etc/ansible/hosts

ansible          --version
ansible-playbook --version
ansible localhost -c local -m setup

sudo apt-get purge      -y python-dev
sudo apt-get autoremove -y
