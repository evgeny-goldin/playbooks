# https://registry.hub.docker.com/u/evgenyg/ruby/

FROM evgenyg/ansible:1.7.2
ADD  playbooks /playbooks
RUN  ansible-playbook /playbooks/ruby-ubuntu.yml -c local
ENV  PATH /usr/local/rvm/rubies/default/bin:/usr/local/rvm/gems/default/bin:$PATH
