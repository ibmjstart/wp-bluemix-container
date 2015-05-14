#!/bin/bash

# export db creds as env variables
export WORDPRESS_DB_USER=$(/vcap_parse.sh cleardb 0 credentials username)
export WORDPRESS_DB_PASSWORD=$(/vcap_parse.sh cleardb 0 credentials password)
export WORDPRESS_DB_HOST=$(/vcap_parse.sh cleardb 0 credentials hostname):3306
export WORDPRESS_DB_NAME=$(/vcap_parse.sh cleardb 0 credentials name)

# Fix the entry point we overrode earlier (from end of wordpress:latest)
/entrypoint.sh
apache2-foreground