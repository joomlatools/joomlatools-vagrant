#!/bin/bash

ARCHIVE="${1:-/vagrant/joomla-box-backup.tar}"
TEMP_DIR="/tmp/restore"

if [ ! -f $ARCHIVE ]; then
    echo "Backup archive $ARCHIVE not found, aborting." 1>&2
    exit 1
fi

if [ -d $TEMP_DIR ]; then
    rm -f $TEMP_DIR/*.gz
    rm -f $TEMP_DIR/*.conf
    rm -f $TEMP_DIR/*.sql
else
    mkdir -p $TEMP_DIR
fi

tar -xf $ARCHIVE -C $TEMP_DIR

echo "Restoring virtual hosts:"
for VHOST in $TEMP_DIR/vhost-1-*.conf.gz; do
  if [ ! -e "$VHOST" ]
  then
    echo "No virtual hosts found. Nothing to do."
    break
  fi

  FILENAME=$(basename "$VHOST")
  SITENAME="${FILENAME/vhost-1-/}"
  SITENAME="${SITENAME/.conf.gz/}"

  echo " * $SITENAME"

  gunzip $VHOST
  VHOST="${VHOST/.gz/}"

  # Make sure VirtualHosts are listening on port 8080 instead of 80
  # (we changed the port since adding Varnish support)
  if grep -Fxq "<VirtualHost *:80>" $VHOST
  then
      sed -i'.bak' 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/g' $VHOST
  fi

  sudo mv $VHOST "/etc/apache2/sites-available/1-${SITENAME}.conf" || { echo "Failed to install $SITENAME! Aborting." 1>&2; exit 1; }
  sudo a2ensite "1-$SITENAME" &> /dev/null || { echo "Failed to enable $SITENAME! Aborting." 1>&2; exit 1; }
done

sudo service apache2 restart
sudo service varnish restart

echo "Restoring databases:"

for DB in $TEMP_DIR/mysql-*.sql.gz; do
  if [ ! -e "$DB" ]
  then
    echo "No database dumps found. Nothing to do."
    break
  fi

  FILENAME=$(basename $DB)
  DBNAME=${FILENAME%.*}
  DBNAME="${DBNAME/.sql.gz/}"

  echo " * $DBNAME"

  gunzip $DB
  DB="${DB/.gz/}"

  mysql -uroot -proot < $DB || { echo "Failed to import database $DBNAME! Aborting." 1>&2; exit 1; }
done

rm -rf $TEMP_DIR

echo "Succesfully restored your hosts and databases. You can safely delete the joomla-box-backup.tar file after validating your setup."