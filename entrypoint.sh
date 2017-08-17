#!/usr/bin/env bash

APACHE_CONF_DIR="/etc/apache2/"
REVIVE_DIR="/var/www/html"

# Start apache in the foreground
source ${APACHE_CONF_DIR}/envvars
# Tail is for the logs to go to stdout.
apachectl -d ${APACHE_CONF_DIR} -f apache2.conf -e info -DFOREGROUND & tail -f /var/log/apache2/*
