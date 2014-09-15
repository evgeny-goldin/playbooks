
#### This repo contains [Ansible](http://www.ansible.com/) Playbooks/Roles for installing the following packages on Ubuntu:

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

#### Usage:

* To create VMs, if you have **Vagrant** and **VirtualBox** installed locally:

  vagrant up [jenkins](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/jenkins-ubuntu.yml) / [asgard](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/asgard-ubuntu.yml) / [mysql](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/mysql-ubuntu.yml) / [packer](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/packer-ubuntu.yml)`

  `"packer"` box comes with Docker, Ansible, Vagrant, Virtualbox, and Packer installed

* To provision the local box, if you have **Ansible** installed locally:

  ansible-playbook packer-ubuntu.yml -c local -i "127.0.0.1,"
