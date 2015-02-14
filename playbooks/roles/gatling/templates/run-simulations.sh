#!/bin/bash

mkdir -p '{{ reports_dir }}'

{% for simulation in simulations %}

echo "-=-= Running simulation {{ simulation }} =-=-"
STARTTIME=$(date +%s)

JAVA_OPTS="{{ gatling_java_opts | default('') }}" '{{ gatling_sh }}' -m \
    --output-name    '{{ simulation }}' \
    --simulation     '{{ simulation }}' \
    --results-folder '{{ reports_dir }}' 2>&1 | tee -a '{{ reports_dir }}/{{ simulation }}.log'

ENDTIME=$(date +%s)
echo "-=-= Running simulation {{ simulation }} - DONE ($(($ENDTIME - $STARTTIME)) sec) =-=-"

echo "-=-= Sleeping for 10 seconds =-=-"
sleep 10

{% endfor %}

{% if reports_archive is defined %}

rm -rf '{{ reports_archive }}'
cd     '{{ reports_dir }}'
echo "-=-= Packing '{{ reports_dir }}' => '{{ reports_archive }}' =-=-"

  {% if reports_archive.endswith( '.tar.gz' ) %}
tar -czf '{{ reports_archive }}' .
  {% endif %}

  {% if reports_archive.endswith( '.zip' ) %}
zip -r9 '{{ reports_archive }}' .
  {% endif %}
{% endif %}
