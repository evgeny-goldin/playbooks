#### Summary

This repo contains **Ansible** [Playbooks](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks) and [Roles](https://github.com/evgeny-goldin/playbooks/tree/master/playbooks/roles) for installing the following tools on Ubuntu:

* [Ansible](http://www.ansible.com/)
* [Artifactory](http://www.jfrog.com/artifactory/) _(standalone or Tomcat)_
* [Asgard](https://github.com/Netflix/asgard)
* [Docker](https://www.docker.com/)
* [Exhibitor](https://github.com/Netflix/exhibitor)
* [etcd](https://github.com/coreos/etcd)
* [Gatling](http://gatling.io/)
* [Gradle](https://www.gradle.org/)
* [Groovy](http://groovy.codehaus.org/)
* [Go](https://golang.org/)
* [Helios](https://github.com/spotify/helios) _(master + agent or a single instance)_
* [Java](http://www.oracle.com/technetwork/java/index.html) _(Oracle JRE, Oracle JDK, DefaultJDK)_
* [Jenkins](https://jenkins-ci.org/)
* [MySQL](https://www.mysql.com/)
* [Nexus](http://www.sonatype.org/nexus/) _(standalone or Tomcat)_
* [Node.js](https://nodejs.org/)
* [Packer](https://www.packer.io/)
* [Ruby](https://www.ruby-lang.org/en/)
* [Scala](http://www.scala-lang.org/)
* [SkyDNS](https://github.com/skynetservices/skydns)
* [Tomcat](https://tomcat.apache.org/)
* [Vagrant](https://www.vagrantup.com/)
* [VirtualBox](https://www.virtualbox.org/)
* [ZooKeeper](https://zookeeper.apache.org/)

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
