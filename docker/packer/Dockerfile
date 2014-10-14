FROM evgenyg/ansible:1.7.2
ADD  playbooks /playbooks
RUN  ansible-playbook /playbooks/packer-ubuntu.yml -c local
