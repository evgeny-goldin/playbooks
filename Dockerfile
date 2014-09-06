FROM   evgenyg/ansible
ADD    playbooks /playbooks
RUN    ansible-playbook /playbooks/jenkins.yml --connection=local
RUN    rm /playbooks/vars.yml
EXPOSE 8080
