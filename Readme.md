<!-- [![Build Status](https://api.shippable.com/projects/5416fa1e50f3833e055aa2a8/badge?branchName=ship)](https://app.shippable.com/projects/5416fa1e50f3833e055aa2a8) -->

This repo contains Ansible [Playbooks](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks) and [Roles](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks/roles) for installing the following packages on Ubuntu:

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

* `<options> = asgard | docker | jenkins | mysql | packer | ruby`

* To create Ubuntu VMs, if you have **Vagrant** and **VirtualBox** installed:

  * `vagrant up <options>`

  All boxes come with Ansible installed so you can re-run the playbook (available at `"/playbooks"`) from within a box:

  * `vagrant ssh <options>`
  * `ansible-playbook /playbooks/<options>-ubuntu.yml -s -c local`


* [`"asgard"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/asgard-ubuntu.yml) playbook installs Java and runs Asgard as an `"asgard"` service.

* [`"docker"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/docker-ubuntu.yml) playbook installs Docker.

* [`"jenkins"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/jenkins-ubuntu.yml) playbook installs Java, Node.js, Npm, Grunt, Bower and Jenkins running as a `"jenkins"` service. Jenkins plugins to install are [configurable](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/roles/jenkins/vars/main.yml).

* [`"mysql"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/mysql-ubuntu.yml) playbook installs MySQL 5.6 running as `"mysql"` service accepting any remote connections. User is "root" with an empty password.

* [`"packer"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/packer-ubuntu.yml) playbook installs Docker, Vagrant, VirtualBox, Ruby and Packer.

* [`"ruby"`](https://github.com/evgeny-goldin/playbooks/blob/master/playbooks/ruby-ubuntu.yml) playbook installs Ruby.

* Packages installed are usually of the latest version, review each role's `"vars/main.yml"` for fine-tuning. Most roles also allow explicit versioning of the package installed.


#### Docker

To create a Docker by running an Ansible playbook:

    FROM evgenyg/ansible:1.8.1
    ADD  playbooks /playbooks
    RUN  ansible-playbook /playbooks/<options>-ubuntu.yml -c local
    ...

See examples for [Ruby](https://github.com/evgeny-goldin/playbooks/blob/master/docker/ruby/Dockerfile) and [Jenkins](https://github.com/evgeny-goldin/playbooks/blob/master/docker/jenkins/Dockerfile) containers.
