
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

* [`"jenkins"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/jenkins-ubuntu.yml) comes with Java, Node.js, Npm, Grunt and Bower installed. Plugins are [configurable](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/roles/jenkins/vars/main.yml).

* [`"asgard"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/asgard-ubuntu.yml) comes with Java and Asgard installed as a service running the standalone jar.

* [`"mysql"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/mysql-ubuntu.yml) comes with MySQL v5.6.x installed.

* [`"packer"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/packer-ubuntu.yml) comes with Docker, Ansible, Vagrant, VirtualBox, and Packer installed.

* Review [each role's](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks/roles) `"vars/main.yml"` for fine-tuning your installation. Some roles allow explicit package versioning, such as those for [Ansible](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/roles/ansible/vars/main.yml), [Vagrant](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/roles/vagrant/vars/main.yml) or [Packer](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/roles/packer/vars/main.yml).
