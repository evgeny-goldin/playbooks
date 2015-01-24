#!/bin/bash

# -------------------------------------------------------------
# Updates Nexus wrapper.conf with additional Java options.
# -------------------------------------------------------------

# Comment out 'wrapper.java.initmemory' section if '-Xms' is present in Java options

if [[ "{{ java_options }}" == *"-Xms"* ]]; then
  sed -i 's/\(wrapper.java.initmemory=.*\)/#\1/' '{{ wrapper_conf }}';
fi

# Comment out 'wrapper.java.maxmemory' section if '-Xmx' is present in Java options

if [[ "{{ java_options }}" == *"-Xmx"* ]]; then
  sed -i 's/\(wrapper.java.maxmemory=.*\)/#\1/' '{{ wrapper_conf }}';
fi

# Split Java options and add numbered 'wrapper.java.additional' sections, starting from (last number + 1)

opts="{{ java_options }}";
arr=(${opts// / });
last_number=$(grep 'wrapper.java.additional' '{{ wrapper_conf }}' | grep -v '^\s*#' | cut -d'.' -f4 | cut -d '=' -f1 | tail -1)

for j in "${!arr[@]}"; do
  echo "wrapper.java.additional.$((j+last_number+1))=${arr[j]}" >> '{{ wrapper_conf }}';
done
