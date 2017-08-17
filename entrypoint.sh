#!/usr/bin/env bash

APACHE_CONF_DIR="/etc/apache2/"
REVIVE_DIR="/var/www/html"

# Copy and chown the files only if revive is not installed.
# This is in case you are using nfs or efs.
if [ ! -f "${REVIVE_DIR}/var/INSTALLED" ]; then
  echo "Revive is not installed copying folder contents"
  rsync -a /tmp/revive/ ${REVIVE_DIR}
  chown -R www-data:www-data ${REVIVE_DIR}
fi

echo "Cleaning up"
rm -rf /tmp/revive/

# Start apache in the foreground
source ${APACHE_CONF_DIR}/envvars
# Tail is for the logs to go to stdout.
apachectl -d ${APACHE_CONF_DIR} -f apache2.conf -e info -DFOREGROUND & tail -f /var/log/apache2/*
