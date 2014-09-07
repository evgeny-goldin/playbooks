#!/bin/bash

AWS_ACCESS_KEY_ID={{ AWS_ACCESS_KEY_ID }} AWS_SECRET_ACCESS_KEY={{ AWS_SECRET_ACCESS_KEY }} java -Xms256m -Xmx1024m -jar "{{ asgard_jar }}"
