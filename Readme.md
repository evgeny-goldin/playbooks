
### This repo contains [Ansible](http://www.ansible.com/) Playbooks/Roles for installing the following packages on Ubuntu:

* [Ansible](http://www.ansible.com/)
* [Asgard](https://github.com/Netflix/asgard)
* [Docker](https://www.docker.com/)
* [Java](http://www.oracle.com/technetwork/java/index.html)
* [Jenkins](http://jenkins-ci.org/)
* [MySQL](http://www.mysql.com/)
* [Node.js](http://nodejs.org/)
* [Packer](http://www.packer.io/)
* [Vagrant](http://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)

### Usage:

* To create VMs, if you have Vagrant and VirtualBox installed locally:

  `vagrant up jenkins / asgard / mysql / packer`

  'packer' box comes with Docker, Ansible, Vagrant, Virtualbox installed

* To provision the local box, if you have ansible installed locally:

  `ansible-playbook packer-ubuntu.yml -c local -i "127.0.0.1,"`
