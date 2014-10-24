#!/bin/bash

source '{{ ruby.rvm.home }}/scripts/rvm'

set -x

rvm get stable
rvm install        '{{ ruby_version }}'
rvm  --default use '{{ ruby_version }}'
gem  --version
rake --version
gem update --system
gem install bundler
gem update
ln -s '{{ ruby.rvm.home }}/gems/ruby-{{ ruby_version }}' '{{ ruby.rvm.home }}/gems/default'
