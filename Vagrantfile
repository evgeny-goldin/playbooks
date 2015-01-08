# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = '2'
CPUS                    = '2'
MEMORY                  = '1024'
TOP_LEVEL_DOMAIN        = 'vm' 
HELIOS_AGENT_PROPERTIES = { playbook: 'helios-agent-ubuntu',
                            zk_host:  "helios-master.#{ TOP_LEVEL_DOMAIN }",
                            zk_port:  2181 }
BOXES                   = {
  # Name of the box (and corresponding playbook) => { playbook's extra variables, :ports is respected by Vagrant }
  # packer:             {},
  # ruby:               {},
  'helios-master'  => { ports: [ 2181,    # ZooKeeper
                                 5801,    # Helios Master
                                 8080 ]}, # Netflix Exhibitor
  'helios-agent-1' => HELIOS_AGENT_PROPERTIES,
  'helios-agent-2' => HELIOS_AGENT_PROPERTIES,
  # jenkins:            { ports: [ 8080 ]},
  # asgard:             { ports: [ 8080 ]},
  # mysql:              { ports: [ 3306 ]},
  # docker:             { ports: [ 3000 ], app_name: 'tsa',
  #                                        image:    'evgenyg/todo-sample-app',
  #                                        env_file: '/playbooks/todo-sample-app.env' }
}

Vagrant.require_version '>= 1.6.5'
Vagrant.configure( VAGRANTFILE_API_VERSION ) do | config |
  
  # https://github.com/phinze/landrush
  # vagrant plugin install landrush
  # vagrant landrush start|stop|restart|status|ls|vms|help 
  # ~/.vagrant.d/data/landrush
  config.landrush.enabled = true
  config.landrush.tld     = TOP_LEVEL_DOMAIN

  BOXES.each_pair { | box, variables |

    box_name = "#{ box }.#{ TOP_LEVEL_DOMAIN }"

    config.vm.define box do | b |
      b.vm.box              = 'ubuntu/trusty64'
      b.vm.box_check_update = true
      b.vm.hostname         = box_name
      b.vm.synced_folder 'playbooks', '/playbooks'

      ( variables[:ports] || [] ).each { | port |  
        b.vm.network 'forwarded_port', guest: port, host: port, auto_correct: true
      }

      config.vm.provider 'virtualbox' do | vb |
        vb.gui  = false
        vb.name = box_name
        # https://www.virtualbox.org/manual/ch08.html
        vb.customize [ 'modifyvm', :id, '--memory', MEMORY, '--cpus', CPUS ]
      end

      config.vm.provision 'ansible' do | ansible |
        # ansible.verbose  = 'vv'
        ansible.playbook   = "playbooks/#{ variables[:playbook] || "#{ box }-ubuntu" }.yml"
        ansible.extra_vars = variables.merge({
          # Uncomment and set to true to forcefully update all packages
          # Uncomment and set to false to disable periodic run
          # Otherwise (when commented out) packages are updated automatically once a day
          # periodic: true
        })
      end
    end
  }
end
