FROM   evgenyg/ansible
ADD    playbooks /playbooks
RUN    ansible-playbook /playbooks/jenkins.yml --connection=local
EXPOSE 8080
CMD    /usr/bin/java -Djava.awt.headless=true -jar /usr/share/jenkins/jenkins.war --webroot=/var/cache/jenkins/war --httpPort=8080 --ajp13Port=-1
