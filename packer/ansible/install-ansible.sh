#!/bin/sh

set -x

sudo apt-get update  -y
sudo apt-get install -y vim htop wget curl git unzip python-pip python-dev
sudo pip install ansible
ansible          --version
ansible-playbook --version
