# https://registry.hub.docker.com/u/evgenyg/ansible/

FROM ubuntu:14.04

RUN apt-get update  -y
RUN apt-get upgrade -y
RUN apt-get install -y vim htop python-pip python-dev
RUN pip install ansible==1.7.1
RUN apt-get purge   -y python-dev

RUN mkdir -p         /etc/ansible
RUN echo localhost > /etc/ansible/hosts

RUN ansible          --version
RUN ansible-playbook --version
