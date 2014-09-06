FROM   evgenyg/ansible
ADD    playbooks /playbooks
RUN    ansible-playbook /playbooks/jenkins.yml --connection=local
EXPOSE 8080
