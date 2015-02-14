# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = '2'

CPUS               = 2
MEMORY             = 1024
VAGRANT_DOMAIN     = 'vm'
DNS_PORT           = 53
MYSQL_PORT         = 3306
ZOOKEEPER_PORT     = 2181
ETCD_PORT          = 4001
HELIOS_MASTER_PORT = 5801
WEB_PORT           = 8080
VERBOSE            = '' # Ansible verbosity level: '', 'v', 'vv', 'vvv', 'vvvv'
REPO_IMPORT        = 'https://s3-eu-west-1.amazonaws.com/evgenyg-ansible/repo-import.zip'
HELIOS_PROPERTIES  = { helios_master:      "helios-master.#{ VAGRANT_DOMAIN }",
                       helios_master_port: HELIOS_MASTER_PORT,
                       zookeeper_port:     ZOOKEEPER_PORT,
                       etcd_port:          ETCD_PORT,
                       domain:             VAGRANT_DOMAIN }
HELIOS_PORTS       = { vagrant_ports: [ DNS_PORT, ZOOKEEPER_PORT, ETCD_PORT, HELIOS_MASTER_PORT ]}

VB_BOXES = {
  jvm:     {},
  packer:  {},
  mysql:   { vagrant_ports: [ MYSQL_PORT ]},
  jenkins: { vagrant_ports: [ WEB_PORT ]},
  'helios-master'  => HELIOS_PROPERTIES.merge( HELIOS_PORTS ),
  'helios-agent1'  => HELIOS_PROPERTIES.merge( playbook:      'helios-agent',
                                               vagrant_ports: [ WEB_PORT ] ),
  'helios-agent2'  => HELIOS_PROPERTIES.merge( playbook:      'helios-agent',
                                               vagrant_ports: [ WEB_PORT ] ),
  helios:             HELIOS_PROPERTIES.merge( HELIOS_PORTS ).merge( helios_master: "helios.#{ VAGRANT_DOMAIN }" ),
  repo:          { port:          WEB_PORT,
                   java_options:  '-server -Xms512m -Xmx800m',
                  #  import:        REPO_IMPORT,
                   vagrant_ports: [ WEB_PORT ],
                   playbook:      'artifactory' },
                  #  playbook:      'nexus' },
  'test-repo' => { reports_dir:       '/opt/gatling-reports',
                   clean_reports:     true,
                   run_simulations:   false,
                   reports_archive:   '/vagrant/gatling-reports.tar.gz',
                   host:              "repo.#{ VAGRANT_DOMAIN }",
                   port:              WEB_PORT,
                  # -------------------------------------------
                  # https://www.jfrog.com/confluence/display/RTF/Artifactory+REST+API#ArtifactoryRESTAPI-ArtifactSearch%28QuickSearch%29
                  # -------------------------------------------
                   repo_name:         'Artifactory',
                   repo:              '/artifactory/<repo>/<artifact>',
                   quick_search:      '/artifactory/api/search/artifact?name=<name>',
                   groupId_search:    '/artifactory/api/search/gavc?g=<g>',
                   artifactId_search: '/artifactory/api/search/gavc?a=<a>',
                   version_search:    '/artifactory/api/search/gavc?v=<v>',
                   gav_search:        '/artifactory/api/search/gavc?g=<g>&a=<a>&v=<v>' }
                  # -------------------------------------------
                  # https://repository.sonatype.org/nexus-indexer-lucene-plugin/default/docs/path__lucene_search.html
                  # -------------------------------------------
                  #  repo_name:         'Nexus',
                  #  repo:              '/nexus/content/repositories/<repo>/<artifact>',
                  #  quick_search:      '/nexus/service/local/lucene/search?count=10000000&q=<name>',
                  #  groupId_search:    '/nexus/service/local/lucene/search?count=10000000&g=<g>',
                  #  artifactId_search: '/nexus/service/local/lucene/search?count=10000000&a=<a>',
                  #  version_search:    '/nexus/service/local/lucene/search?count=10000000&v=<v>',
                  #  gav_search:        '/nexus/service/local/lucene/search?count=10000000&g=<g>&a=<a>&v=<v>' }
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

      ( variables[ :vagrant_ports ] || [] ).each { | port |
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
        ansible.playbook   = "playbooks/#{ variables[ :playbook ] || "#{ box }" }-ubuntu.yml"
        ansible.extra_vars = variables.merge({
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
