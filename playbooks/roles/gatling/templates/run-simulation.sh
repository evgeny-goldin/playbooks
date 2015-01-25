#!/bin/bash

gatling.sh -m --output-name '{{ item }}' --simulation '{{ item }}' --results-folder '{{ reports_dir }}' >> '{{ reports_dir }}/{{ item }}.log' 2>&1
