# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'
CPUS                    = '2'
MEMORY                  = '1024'
BOXES                   = { jenkins: [ 8080 ], asgard: [ 8080 ], mysql: [ 3306 ] }

Vagrant.require_version '>= 1.6.3'
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  BOXES.each_pair { | box, ports |

    box_name = "#{box}-ubuntu"

    config.vm.define box do | b |
      b.vm.box              = 'ubuntu/trusty64'
      b.vm.box_check_update = true
      b.vm.synced_folder 'playbooks', '/playbooks'

      ports.each { | port | b.vm.network 'forwarded_port', guest: port, host: port }

      config.vm.provider 'virtualbox' do | vb |
        vb.gui  = false
        vb.name = box_name
        # https://www.virtualbox.org/manual/ch08.html
        vb.customize [ 'modifyvm', :id, '--memory', MEMORY, '--cpus', CPUS ]
      end

      config.vm.provision 'ansible' do | ansible |
        # ansible.verbose  = 'vv'
        ansible.playbook   = "playbooks/#{box_name}.yml"
        ansible.extra_vars = {
          # Uncomment to forcefully update all packages (otherwise, they're updated automatically once a day)
          # periodic: true
        }
      end
    end
  }

end
