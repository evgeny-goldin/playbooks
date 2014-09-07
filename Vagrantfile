# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'

Vagrant.require_version '>= 1.6.3'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box              = 'ubuntu/trusty64'
  config.vm.box_check_update = true
  config.vm.network 'forwarded_port', guest: 8080, host: 8080
  config.vm.synced_folder 'playbooks', '/playbooks'

  config.vm.provider 'virtualbox' do |vb|
    vb.gui = false
    # https://www.virtualbox.org/manual/ch08.html
    vb.customize ['modifyvm', :id, '--memory', '2048', '--cpus', '2']
  end

  config.vm.provision 'ansible' do |ansible|
    # ansible.verbose  = 'vv'
    ansible.playbook = 'playbooks/jenkins-ubuntu.yml'
  end
end
