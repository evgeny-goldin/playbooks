# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

CPUS               = 2
MEMORY             = 512
VAGRANT_DOMAIN     = 'vm'
ZOOKEEPER_PORT     = 2181
HELIOS_MASTER_PORT = 5801
ETCD_PORT          = 4001
WEB_PORT           = 8080
EXHIBITOR_PORT     = WEB_PORT
ARTIFACTORY_PORT   = WEB_PORT
NEXUS_PORT         = WEB_PORT
DNS_PORT           = 53
VERBOSE            = '' # Ansible verbosity level: '', 'v', 'vv', 'vvv', 'vvvv'
HELIOS_PROPERTIES  = { helios_master:      "helios-master.#{ VAGRANT_DOMAIN }",
                       helios_master_port: HELIOS_MASTER_PORT,
                       zookeeper_port:     ZOOKEEPER_PORT,
                       etcd_port:          ETCD_PORT,
                       exhibitor_port:     EXHIBITOR_PORT,
                       skydns_domain:      VAGRANT_DOMAIN }
HELIOS_PORTS       = { ports: [ DNS_PORT, ZOOKEEPER_PORT, HELIOS_MASTER_PORT, ETCD_PORT, EXHIBITOR_PORT ] }

# Name of the box => { playbook's extra variables, :ports is respected by Vagrant }
BOXES = {
  'helios-master'  => HELIOS_PROPERTIES.merge( HELIOS_PORTS ),
  'helios-agent'   => HELIOS_PROPERTIES,
  helios:             HELIOS_PROPERTIES.merge( HELIOS_PORTS ).merge( helios_master: "helios.#{ VAGRANT_DOMAIN }" ),
  artifactory:          { memory:           1024,
                          artifactory_port: ARTIFACTORY_PORT,
                          ports:            [ ARTIFACTORY_PORT ]},
  nexus:                { memory:     1024,
                          nexus_port: NEXUS_PORT,
                          ports:      [ NEXUS_PORT ]},
  'test-artifactory' => { memory:     1024,
                          playbook:   'test-repo',
                          repo_name:  'Artifactory',
                          report_dir: '/vagrant',
                          repo:       "http://artifactory.#{ VAGRANT_DOMAIN }:#{ ARTIFACTORY_PORT }/artifactory/repo/" },
  'test-nexus'       => { memory:     1024,
                          playbook:   'test-repo',
                          repo_name:  'Nexus',
                          report_dir: '/vagrant',
                          repo:       "http://nexus.#{ VAGRANT_DOMAIN }:#{ NEXUS_PORT }/nexus/content/repositories/central/" },
  # packer:             {},
  # ruby:               {},
  # jenkins:            { ports: [ WEB_PORT ]},
  # asgard:             { ports: [ WEB_PORT ]},
  # mysql:              { ports: [ 3306 ]},
  # docker:             { ports: [ 3000 ], app_name: 'tsa',
  #                                        image:    'evgenyg/todo-sample-app',
  #                                        env_file: '/playbooks/todo-sample-app.env' }
}

Vagrant.require_version '>= 1.7.0'
Vagrant.configure( VAGRANTFILE_API_VERSION ) do | config |

  # https://github.com/phinze/landrush
  # vagrant plugin install landrush
  # vagrant landrush start|stop|restart|status|ls|vms|help
  # ~/.vagrant.d/data/landrush
  config.landrush.enabled = true
  config.landrush.tld     = VAGRANT_DOMAIN

  BOXES.each_pair { | box, variables |

    box_name = "#{ box }.#{ VAGRANT_DOMAIN }"

    config.vm.define box do | b |
      b.vm.box              = 'ubuntu/trusty64'
      b.vm.box_check_update = true
      b.vm.hostname         = box_name # 1) Vagrant will cut out everything starting from the first dot but ..
                                       # 2) Landrush needs a proper hostname ending with config.landrush.tld
      b.vm.synced_folder 'playbooks', '/playbooks'

      ( variables[ :ports ] || [] ).each { | port |
        b.vm.network 'forwarded_port', guest: port, host: port, auto_correct: true
      }

      config.vm.provider 'virtualbox' do | vb |
        vb.gui  = false
        vb.name = box_name
        # https://www.virtualbox.org/manual/ch08.html
        vb.customize [ 'modifyvm', :id,
                       '--memory', variables[ :memory ] || MEMORY,
                       '--cpus',   variables[ :cpus ]   || CPUS ]
      end

      config.vm.provision 'ansible' do | ansible |
        ansible.verbose    = VERBOSE if VERBOSE != ''
        ansible.playbook   = "playbooks/#{ variables[ :playbook ] || "#{ box }-ubuntu" }.yml"
        ansible.extra_vars = variables.merge({
          # Uncomment and set to true to forcefully update all packages
          # Uncomment and set to false to disable periodic run
          # Otherwise (when commented out) packages are updated automatically once a day
          # periodic: true
          # periodic: false
        })
      end
    end
  }
end
