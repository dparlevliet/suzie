#!/bin/bash

echo "Please enter the hostname or IP (default: localhost): "
read answer
MYSQL_HOST=$answer
if [[ $MYSQL_HOST == "" ]]; then
  MYSQL_HOST="localhost"
fi

echo "Please enter the username (default: root): "
read answer
MYSQL_USER=$answer
if [[ $MYSQL_USER == "" ]]; then
  MYSQL_USER="root"
fi

echo "Is this user a superuser? (yes/no) (default: yes):"
read answer
MYSQL_SUPER=$answer
if [[ $MYSQL_SUPER == "" ]]; then
  MYSQL_SUPER="yes"
fi

echo "Please enter the password: "
read answer
MYSQL_PASS=$answer

echo "Please enter the name of the database: "
read answer
MYSQL_DB=$answer

echo "Please enter the destination (default: ~/Dropbox/db.sql): "
read answer
MYSQL_DEST=$answer
if [[ $MYSQL_DEST == "" ]]; then
  MYSQL_DEST=~/Dropbox/db.sql
fi

if [[ $MYSQL_SUPER == "y" || $MYSQL_SUPER == 'yes' ]]; then
  mysql \
    --user=$MYSQL_USER \
    --host=$MYSQL_HOST \
    --password=$MYSQL_PASS \
  --execute="SET GLOBAL net_write_timeout=360; SET GLOBAL net_read_timeout=360; SET GLOBAL max_allowed_packet=1024*1024*1024;" > /dev/null
fi

mysqldump \
  --opt \
  --quick \
  --hex-blob \
  --max_allowed_packet=1G \
  --user=$MYSQL_USER \
  --password=$MYSQL_PASS \
  --host=$MYSQL_HOST \
  --add-drop-table=true \
  --complete-insert=true  \
  --lock-tables=false \
  --databases $MYSQL_DB > $MYSQL_DEST