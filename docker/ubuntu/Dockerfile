FROM evgenyg/ansible:1.7.1
ADD  playbooks /playbooks
RUN  ansible-playbook /playbooks/base-ubuntu.yml -c local
