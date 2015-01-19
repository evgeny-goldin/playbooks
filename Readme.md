<!-- [![Build Status](https://api.shippable.com/projects/5416fa1e50f3833e055aa2a8/badge?branchName=ship)](https://app.shippable.com/projects/5416fa1e50f3833e055aa2a8) -->

#### Summary

This repo contains **Ansible** [Playbooks](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks) and [Roles](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks/roles) for installing the following packages on Ubuntu:

* [Ansible](http://www.ansible.com/)
* [Artifactory](http://www.jfrog.com/artifactory/) _(standalone or Tomcat)_
* [Asgard](https://github.com/Netflix/asgard)
* [Docker](https://www.docker.com/)
* [Exhibitor](https://github.com/Netflix/exhibitor)
* [etcd](https://github.com/coreos/etcd)
* [Go](https://golang.org/)
* [Helios](https://github.com/spotify/helios)
* [Java](http://www.oracle.com/technetwork/java/index.html) _(Oracle JRE, Oracle JDK, DefaultJDK)_
* [Jenkins](https://jenkins-ci.org/)
* [MySQL](https://www.mysql.com/)
* [Nexus](http://www.sonatype.org/nexus/) _(standalone or Tomcat)_
* [Node.js](https://nodejs.org/)
* [Packer](https://www.packer.io/)
* [Ruby](https://www.ruby-lang.org/en/)
* [SkyDNS](https://github.com/skynetservices/skydns)
* [Tomcat](https://tomcat.apache.org/)
* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)
* [ZooKeeper](https://zookeeper.apache.org/)

#### Usage

* `<box>` is one of:

    * `artifactory`
    * `asgard`
    * `docker`
    * `helios-agent`
    * `helios-master`
    * `jenkins`
    * `mysql`
    * `nexus`
    * `packer`
    * `ruby`

* You can create Ubuntu VMs if **Vagrant** and **VirtualBox** are installed:

  * `vagrant up <box>`

  All boxes come with Ansible installed so you can re-run the playbook from within a box:

  * `vagrant ssh <box>`
  * `ansible-playbook /playbooks/<box>-ubuntu.yml -s -c local`

#### Docker

A Dockerfile for creating an image by running an Ansible playbook may look like this:

    FROM evgenyg/ansible
    ADD  playbooks /playbooks
    RUN  ansible-playbook /playbooks/<box>-ubuntu.yml -c local
    ...

See examples of Dockerfiles for [Ruby](https://github.com/evgeny-goldin/playbooks/blob/master/docker/ruby/Dockerfile) and [Jenkins](https://github.com/evgeny-goldin/playbooks/blob/master/docker/jenkins/Dockerfile) images.

#### Docker Hub

Some Docker images based on the playbooks above are published on Docker Hub as:

* [`evgenyg/ansible`](https://registry.hub.docker.com/u/evgenyg/ansible/)
* [`evgenyg/ruby`](https://registry.hub.docker.com/u/evgenyg/ruby/)
