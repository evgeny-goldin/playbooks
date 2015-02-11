#!/bin/bash

mkdir -p '{{ reports_dir }}'

{% for simulation in simulations %}

echo "-=-= Running simulation {{ simulation }} =-=-"

JAVA_OPTS="{{ gatling_java_opts | default('') }}" '{{ gatling_sh }}' -m \
    --output-name    '{{ simulation }}' \
    --simulation     '{{ simulation }}' \
    --results-folder '{{ reports_dir }}' >> '{{ reports_dir }}/{{ simulation }}.log' 2>&1

echo "-=-= Running simulation {{ simulation }} - DONE =-=-"
sleep 10

{% endfor %}

{% if reports_archive is defined %}

rm -rf '{{ reports_archive }}'
cd     '{{ reports_dir }}'

  {% if reports_archive.endswith( '.tar.gz' ) %}
tar -czf '{{ reports_archive }}' .
  {% endif %}

  {% if reports_archive.endswith( '.zip' ) %}
zip -r9 '{{ reports_archive }}' .
  {% endif %}
{% endif %}
