#!/bin/bash

ARCHIVE="/tmp/joomla-box-backup.tar"
TEMP_DIR="/tmp/backup"

MYSQL_USER="root"
MYSQL_PASSWORD="root"

tar -cvf $ARCHIVE --files-from /dev/null

mkdir -p "$TEMP_DIR/"
cd $TEMP_DIR

for VHOST in /etc/apache2/sites-available/1-*.conf; do
  FILENAME=$( basename "$VHOST" )
  gzip < $VHOST > "$TEMP_DIR/vhost-$FILENAME.gz"
  tar --append --file=$ARCHIVE "vhost-$FILENAME.gz"
  rm -f "vhost-$FILENAME.gz"
done

DATABASES=`mysql --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)"`

for DB in $DATABASES; do
  mysqldump --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $DB | gzip > "$TEMP_DIR/mysql-$DB.sql.gz"
  tar --append --file=$ARCHIVE "mysql-$DB.sql.gz"
  rm -f mysql-$DB.sql.gz
done

mv $ARCHIVE /vagrant/