#!/bin/bash

source '{{ ruby.rvm.home }}/scripts/rvm'

set -x

rvm get stable
rvm --version
rvm install        '{{ ruby_version }}'
rvm  --default use '{{ ruby_version }}'
gem  --version
rake --version

gem update --system

{% for gem in ruby.gems %}
gem install '{{ gem }}'
{% endfor %}

gem update
