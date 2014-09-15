
#### This repo contains Ansible [Playbooks](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks) and [Roles](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks/roles) for installing the following packages on Ubuntu:

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

  * `vagrant up jenkins/asgard/mysql/packer`

* To provision the local box, if you have **Ansible** installed locally:

  * `cd playbooks`
  * `ansible-playbook jenkins/asgard/mysql/packer-ubuntu.yml -c local -i "127.0.0.1,"`

* `"packer"` box comes with Docker, Ansible, Vagrant, VirtualBox, and Packer installed.

* Review [each role's](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks/roles) `"vars/main.yml"` for fine-tuning your installation.
