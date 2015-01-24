#!/bin/bash

# Updates Nexus wrapper.conf with additional Java options.

if [[ "{{ java_options }}" == *"-Xms"* ]]; then
  sed -i 's/\(wrapper.java.initmemory=.*\)/#\1/' '{{ wrapper_conf }}';
fi

if [[ "{{ java_options }}" == *"-Xmx"* ]]; then
  sed -i 's/\(wrapper.java.maxmemory=.*\)/#\1/'  '{{ wrapper_conf }}';
fi

opts="{{ java_options }}";
arr=(${opts// / });

for j in "${!arr[@]}"; do
  echo "wrapper.java.additional.$((j+5))=${arr[j]}" >> '{{ wrapper_conf }}';
done
