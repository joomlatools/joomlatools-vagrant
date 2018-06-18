#!/bin/bash

ARCHIVE="${1:-/vagrant/joomla-box-backup.tar}"

if [ ! -e "$ARCHIVE" ] ; then
    touch "$ARCHIVE"
fi

if [ ! -w "$ARCHIVE" ] ; then
    echo "Cannot write to $ARCHIVE!"
    exit 1
fi

TMP_ARCHIVE="/tmp/joomla-box-backup.tar"
TEMP_DIR="/tmp/backup"

MYSQL_USER="root"
MYSQL_PASSWORD="root"

tar -cvf $TMP_ARCHIVE --files-from /dev/null

mkdir -p "$TEMP_DIR/"
cd $TEMP_DIR

backup_vhosts() {
    local APPLICATION=$1

    echo "Backing up your ${APPLICATION} virtual hosts:"

    for VHOST in /etc/${APPLICATION}/sites-available/1-*.conf; do
      if [ ! -e "$VHOST" ]
      then
        echo "No ${APPLICATION} virtual hosts found. Nothing to do."
        break
      fi

      FILENAME=$( basename "$VHOST" )
      SITENAME=${FILENAME%.*}
      SITENAME=${SITENAME:2}

      echo " * $SITENAME"

      gzip < $VHOST > "$TEMP_DIR/vhost-${APPLICATION}-$FILENAME.gz"
      tar --append --file=$TMP_ARCHIVE "vhost-${APPLICATION}-$FILENAME.gz"
      rm -f "vhost-${APPLICATION}-$FILENAME.gz"
    done
}

backup_vhosts apache2
backup_vhosts nginx

echo "Backing up your MySQL databases:"

DATABASES=`mysql --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql)"`

for DB in $DATABASES; do
  echo " * $DB"

  mysqldump --force --opt --user=$MYSQL_USER -p$MYSQL_PASSWORD --databases $DB | gzip > "$TEMP_DIR/mysql-$DB.sql.gz"
  tar --append --file=$TMP_ARCHIVE "mysql-$DB.sql.gz"
  rm -f mysql-$DB.sql.gz
done

mv $TMP_ARCHIVE $ARCHIVE
echo "Backup created in $ARCHIVE"