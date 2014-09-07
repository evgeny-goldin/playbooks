# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'
CPUS                    = '2'
MEMORY                  = '2048'

Vagrant.require_version '>= 1.6.3'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define 'jenkins' do | jenkins |
    jenkins.vm.box              = 'ubuntu/trusty64'
    jenkins.vm.box_check_update = true
    jenkins.vm.network 'forwarded_port', guest: 8080, host: 8080
    jenkins.vm.synced_folder 'playbooks', '/playbooks'

    config.vm.provider 'virtualbox' do |vb|
      vb.gui  = false
      vb.name = 'jenkins-ubuntu'
      # https://www.virtualbox.org/manual/ch08.html
      vb.customize [ 'modifyvm', :id, '--memory', MEMORY, '--cpus', CPUS ]
    end

    config.vm.provision 'ansible' do |ansible|
      # ansible.verbose  = 'vv'
      ansible.playbook   = 'playbooks/jenkins-ubuntu.yml'
      ansible.extra_vars = {
        # Uncomment to forcefully update all packages (otherwise, they're updated automatically once a day)
        # periodic: true
      }
    end
  end

  config.vm.define 'asgard' do | asgard |
    asgard.vm.box              = 'ubuntu/trusty64'
    asgard.vm.box_check_update = true
    asgard.vm.network 'forwarded_port', guest: 8080, host: 8080
    asgard.vm.synced_folder 'playbooks', '/playbooks'

    config.vm.provider 'virtualbox' do |vb|
      vb.gui  = false
      vb.name = 'asgard-ubuntu'
      # https://www.virtualbox.org/manual/ch08.html
      vb.customize [ 'modifyvm', :id, '--memory', MEMORY, '--cpus', CPUS ]
    end

    config.vm.provision 'ansible' do |ansible|
      # ansible.verbose  = 'vv'
      ansible.playbook   = 'playbooks/asgard-ubuntu.yml'
      ansible.extra_vars = {
        # Uncomment to forcefully update all packages (otherwise, they're updated automatically once a day)
        # periodic: true
      }
    end
  end
end
