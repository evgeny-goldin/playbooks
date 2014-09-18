#!/bin/bash
# http://stackoverflow.com/a/4007243/472153

source {{ ubuntu.envs_dir }}/rvm.sh
source {{ ubuntu.envs_dir }}/ruby.sh

rvm use     '{{ ruby_version }}'
rvm default '{{ ruby_version }}'
rvm gemset create global
rvm gemset use    global
gem install {{ gems }} --no-rdoc --no-ri
