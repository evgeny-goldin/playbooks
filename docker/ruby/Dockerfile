# https://registry.hub.docker.com/u/evgenyg/ruby/

FROM evgenyg/ansible:1.7.2
ADD  playbooks /playbooks
RUN  ansible-playbook /playbooks/ruby-ubuntu.yml -c local
CMD  [ "/bin/bash", "-c", "source /.bash_profile; /bin/bash" ]
