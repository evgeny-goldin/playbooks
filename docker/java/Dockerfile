# https://registry.hub.docker.com/u/evgenyg/java/

FROM evgenyg/ansible
ADD  playbooks /playbooks
RUN  ansible-playbook /playbooks/java-ubuntu.yml -c local
CMD  [ "/bin/bash" ]
