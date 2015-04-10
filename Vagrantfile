# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

def add_ip_boxes( name, number, base_ip, ips_property = nil, properties = {} )
  number > 1 or raise "Number of #{name} boxes #{number} is not positive"
  # List of IP numbers for all boxes: 192.168.50.40, 192.168.50.41, 192.168.50.42, etc.
  ips = ( 0 ... number ).map{ |j| base_ip.gsub( /(\d+)$/ ){ | match | ( match.to_i + j ).to_s }}

  ( 0 ... number ).each{ |j|
    box_properties = properties.merge( static_ip: ips[ j ] )
    box_properties.merge!( ips_property => ips ) if ips_property
    VB_BOXES[ "#{ name }#{ j + 1 }" ] = box_properties
    # puts "'#{ name }#{ j + 1 }' IP = #{ ips[ j ] }"
  }
end

# Adds N boxes using the base name specified
def add_boxes( name, number, properties = {} )
  number > 1 or raise "Number of #{name} boxes #{number} is not positive"
  ( 1 .. number ).each{ |j| VB_BOXES[ "#{ name }#{ j }" ] = properties }
end


CPUS               = 2
MEMORY             = 1024
VAGRANT_DOMAIN     = 'vm'
DNS_PORT           = 53
MYSQL_PORT         = 3306
ZOOKEEPER_PORT     = 2181
ETCD_PORT          = 4001
HELIOS_MASTER_PORT = 5801
WEB_PORT           = 8080
DEBUG_PORT         = 8111
VERBOSE            = '' # Ansible verbosity level: '', 'v', 'vv', 'vvv', 'vvvv'
REPO_IMPORT        = 'https://s3-eu-west-1.amazonaws.com/evgenyg-ansible/repo-import.zip'
HELIOS_PROPERTIES  = { helios_master: "helios-master.#{ VAGRANT_DOMAIN }",
                       domain:        VAGRANT_DOMAIN,
                       use_consul:    false }
HELIOS_PORTS       = [ DNS_PORT, ZOOKEEPER_PORT, ETCD_PORT, HELIOS_MASTER_PORT ]

VB_BOXES = {
  jvm:      {},
  packer:   {},
  mysql:    { vagrant_ports: [ MYSQL_PORT ]},
  jenkins:  { vagrant_ports: [ WEB_PORT ]},
  teamcity: { vagrant_ports: [ WEB_PORT, DEBUG_PORT ], memory: 4096, cpus: 4 },
  helios:  HELIOS_PROPERTIES.merge( vagrant_ports: HELIOS_PORTS,
                                    helios_master: "helios.#{ VAGRANT_DOMAIN }" ),
  repo:          { memory:          2048, # For Artifactory MySQL
                   port:            WEB_PORT,
                   import:          REPO_IMPORT,
                   vagrant_ports:   [ WEB_PORT ],
                   playbook:        'artifactory' },
                  #  playbook:        'nexus' },
  'test-repo' => { reports_dir:     '/opt/gatling-reports',
                   reports_archive: '/vagrant/gatling-reports.tar.gz',
                   upload:          REPO_IMPORT,
                   clean_reports:   true,
                   run_simulations: false,
                   host:            "repo.#{ VAGRANT_DOMAIN }",
                   port:            WEB_PORT,
                   repo_name:       'Artifactory' }
                  #  repo_name:       'Nexus' }
}

add_ip_boxes( 'zookeeper',  3, '192.168.50.40', 'zk_instances', { zk_cluster_test: false })
add_boxes( 'helios-master', 2, HELIOS_PROPERTIES.merge( vagrant_ports: HELIOS_PORTS ))
add_boxes( 'helios-agent',  2, HELIOS_PROPERTIES.merge( vagrant_ports: [ WEB_PORT ] ))

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

      b.vm.network 'private_network', ip: variables[ :static_ip ] if variables[ :static_ip ]

      ( variables[ :vagrant_ports ] || [] ).each { | port |
        # https://docs.vagrantup.com/v2/networking/forwarded_ports.html
        b.vm.network 'forwarded_port', guest: port, host: port, auto_correct: true, protocol: 'tcp'
      }

      ( variables[ :vagrant_ports_udp ] || [] ).each { | port |
        # https://docs.vagrantup.com/v2/networking/forwarded_ports.html
        b.vm.network 'forwarded_port', guest: port, host: port, auto_correct: true, protocol: 'udp'
      }

      b.vm.provider :virtualbox do | vb |
        vb.gui  = false
        vb.name = box_name
        # https://www.virtualbox.org/manual/ch08.html
        # http://superuser.com/a/883328/239763
        vb.customize [ 'modifyvm', :id,
                       '--natdnshostresolver1', 'on',
                       '--memory', variables[ :memory ] || MEMORY,
                       '--cpus',   variables[ :cpus ]   || CPUS ]
      end

      b.vm.provision :ansible do | ansible |
        ansible.verbose  = VERBOSE if VERBOSE != ''
        ansible.playbook = "playbooks/#{ variables[ :playbook ] || "#{ box.to_s.gsub( /\d+$/, '' ) }" }-ubuntu.yml"

        box_variables = Hash[ variables ]
        [ :vagrant_ports, :vagrant_ports_udp, :static_ip, :memory, :cpus, :playbook ].each{ |v| box_variables.delete(v) }
        ansible.extra_vars = box_variables.merge({
          # Uncomment and set to true to forcefully update all packages
          # Uncomment and set to false to disable periodic run
          # Otherwise (when commented out) packages are updated automatically once a day
          # periodic: true,
          # periodic: false,

          # Uncomment to simulate a Docker container behavior (less packages are installed)
          # is_docker: true
        })
      end
    end
  }
end
