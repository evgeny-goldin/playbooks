FROM       evgenyg/ansible
ADD        playbooks /playbooks
RUN        ansible-playbook /playbooks/jenkins.yml --connection=local
ENTRYPOINT service jenkins start
EXPOSE     8080
