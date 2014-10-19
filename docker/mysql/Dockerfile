# https://registry.hub.docker.com/u/evgenyg/mysql/

FROM   evgenyg/ansible:1.7.2
EXPOSE 3306
VOLUME /var/lib/mysql
ADD    playbooks /playbooks
ADD    docker/mysql/mysql-start.sh /opt/mysql-start.sh
RUN    ansible-playbook /playbooks/mysql-ubuntu.yml -c local -e "start_service=false"
CMD    [ "/bin/bash", "/opt/mysql-start.sh" ]
