# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

CPUS               = 2
MEMORY             = 512
VAGRANT_DOMAIN     = 'vm'
DNS_PORT           = 53
ZOOKEEPER_PORT     = 2181
ETCD_PORT          = 4001
HELIOS_MASTER_PORT = 5801
WEB_PORT           = 8080
VERBOSE            = '' # Ansible verbosity level: '', 'v', 'vv', 'vvv', 'vvvv'
M2_REPO_IMPORT     = 'https://s3-eu-west-1.amazonaws.com/evgenyg-ansible/m2-import.zip'
HELIOS_PROPERTIES  = { helios_master:      "helios-master.#{ VAGRANT_DOMAIN }",
                       helios_master_port: HELIOS_MASTER_PORT,
                       zookeeper_port:     ZOOKEEPER_PORT,
                       etcd_port:          ETCD_PORT,
                       exhibitor_port:     WEB_PORT,
                       skydns_domain:      VAGRANT_DOMAIN }
HELIOS_PORTS       = { ports: [ DNS_PORT, ZOOKEEPER_PORT, HELIOS_MASTER_PORT, ETCD_PORT, WEB_PORT ] }

VB_BOXES = {
  'helios-master'  => HELIOS_PROPERTIES.merge( HELIOS_PORTS ),
  'helios-agent'   => HELIOS_PROPERTIES,
  helios:             HELIOS_PROPERTIES.merge( HELIOS_PORTS ).merge( helios_master: "helios.#{ VAGRANT_DOMAIN }" ),
  repo:          { memory:       1024,
                   port:         WEB_PORT,
                   java_options: '-server -Xms512m -Xmx800m',
                  #  import:       M2_REPO_IMPORT,
                   ports:        [ WEB_PORT ],
                   playbook:     'artifactory-ubuntu' },
                  #  playbook:     'nexus-ubuntu' },
  'test-repo' => { memory:          1024,
                   reports_dir:     '/opt/gatling-reports',
                   reports_archive: '/vagrant/gatling.tar.gz',
                   clean_reports:   true,
                   host:            "repo.#{ VAGRANT_DOMAIN }",
                   port:            WEB_PORT,
                   repo_name:       'Artifactory', path: '/artifactory/repo/' }
                  #  repo_name:       'Nexus', path: '/nexus/content/repositories/central/' }
}

Vagrant.require_version '>= 1.7.0'
Vagrant.configure( VAGRANTFILE_API_VERSION ) do | config |

  # https://github.com/phinze/landrush
  # vagrant plugin install landrush
  # vagrant landrush start|stop|restart|status|ls|vms|help
  # ~/.vagrant.d/data/landrush
  config.landrush.enabled = true
  config.landrush.tld     = VAGRANT_DOMAIN

  VB_BOXES.each_pair { | box, variables |

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

      b.vm.provider :virtualbox do | vb |
        vb.gui  = false
        vb.name = box_name
        # https://www.virtualbox.org/manual/ch08.html
        vb.customize [ 'modifyvm', :id,
                       '--memory', variables[ :memory ] || MEMORY,
                       '--cpus',   variables[ :cpus ]   || CPUS ]
      end

      b.vm.provision :ansible do | ansible |
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
