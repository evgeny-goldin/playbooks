# https://registry.hub.docker.com/u/evgenyg/mysql/

FROM   evgenyg/ansible:1.7.2
ADD    playbooks /playbooks
EXPOSE 3306
RUN    ansible-playbook /playbooks/mysql-ubuntu.yml -c local -e "start_service=false"
CMD    service mysql start && tail -f /var/log/mysql/*.log
