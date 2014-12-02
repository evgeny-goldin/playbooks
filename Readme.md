<!-- [![Build Status](https://api.shippable.com/projects/5416fa1e50f3833e055aa2a8/badge?branchName=ship)](https://app.shippable.com/projects/5416fa1e50f3833e055aa2a8) -->

#### This repo contains Ansible [Playbooks](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks) and [Roles](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks/roles) for installing the following packages on Ubuntu:

* [Ansible](http://www.ansible.com/)
* [Asgard](https://github.com/Netflix/asgard)
* [Docker](https://www.docker.com/)
* [Java](http://www.oracle.com/technetwork/java/index.html)
* [Jenkins](http://jenkins-ci.org/)
* [MySQL](http://www.mysql.com/)
* [Node.js](http://nodejs.org/)
* [Packer](http://www.packer.io/)
* [Ruby](https://www.ruby-lang.org/en/)
* [Vagrant](http://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)

#### Usage:

* To create VMs, if you have **Vagrant** and **VirtualBox** installed locally:

  * `vagrant up asgard|docker|jenkins|mysql|packer|ruby`

* To provision the local box, if you have **Ansible** installed:

  * `cd playbooks`
  * `ansible-playbook asgard|docker|jenkins|mysql|packer|ruby-ubuntu.yml -c local -i "127.0.0.1,"`

* All boxes come with Ansible installed so you can re-run the playbook (available at `"/playbooks"`) from within a box.

* [`"asgard"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/asgard-ubuntu.yml) comes with Java and Asgard running as an `"asgard"` service.

* [`"docker"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/docker-ubuntu.yml) comes with Docker.

* [`"jenkins"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/jenkins-ubuntu.yml) comes with Java, Node.js, Npm, Grunt, Bower and Jenkins running as a `"jenkins"` service. Jenkins plugins to install are [configurable](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/roles/jenkins/vars/main.yml).

* [`"mysql"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/mysql-ubuntu.yml) comes with MySQL 5.6 running as `"mysql"` service accepting any remote connections. User is "root" with an empty password.

* [`"packer"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/packer-ubuntu.yml) comes with Docker, Vagrant, VirtualBox, Ruby and Packer.

* [`"ruby"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/ruby-ubuntu.yml) comes with Ruby.

* Review [each role's](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks/roles) `"vars/main.yml"` for fine-tuning your installation. Most roles allow explicit versioning of the package installed.

* To create Docker images with Ansible playbooks:

      FROM evgenyg/ansible:1.8.1
      ADD  playbooks /playbooks
      RUN  ansible-playbook /playbooks/asgard|docker|jenkins|mysql|packer|ruby-ubuntu.yml -c local
      ...

  See examples for [Ruby](https://github.com/evgeny-goldin/playbooks/blob/master/docker/ruby/Dockerfile) and [Jenkins](https://github.com/evgeny-goldin/playbooks/blob/master/docker/jenkins/Dockerfile).
