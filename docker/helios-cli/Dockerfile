# https://registry.hub.docker.com/u/evgenyg/helios-cli/

FROM evgenyg/java:jre-1.8
ADD  playbooks /playbooks
RUN  ansible-playbook /playbooks/helios-cli-ubuntu.yml -c local -e "install_java=false helios_master=d helios_master_port=d zookeeper_port=d etcd_port=d domain=d"
