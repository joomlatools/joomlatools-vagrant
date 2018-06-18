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

restore_vhosts() {
    local APPLICATION=$1

    echo "Restoring ${APPLICATION} virtual hosts:"

    for VHOST in $TEMP_DIR/vhost-$APPLICATION-1-*.conf.gz; do
      if [ ! -e "$VHOST" ]
      then
        echo "No ${APPLICATION} virtual hosts found. Nothing to do."
        break
      fi

      FILENAME=$(basename "$VHOST")
      SITENAME="${FILENAME/vhost-${APPLICATION}-1-/}"
      SITENAME="${SITENAME/.conf.gz/}"

      echo " * $SITENAME"

      gunzip $VHOST
      VHOST="${VHOST/.gz/}"

      if [ "${APPLICATION}" == "apache2" ]
      then
          # Make sure VirtualHosts are listening on port 80 instead of 8080
          # (we changed the Apache port back to 80, see https://github.com/joomlatools/joomlatools-vagrant/issues/85)
          if grep -Fxq "<VirtualHost *:8080>" $VHOST
          then
              sed -i'.bak' 's/<VirtualHost \*:8080>/<VirtualHost \*:80>/g' $VHOST
          fi
      fi

      sudo mv $VHOST "/etc/${APPLICATION}/sites-available/1-${SITENAME}.conf" || { echo "Failed to install ${APPLICATION} ${SITENAME}! Aborting." 1>&2; exit 1; }
      sudo ln -s "/etc/${APPLICATION}/sites-available/1-${SITENAME}.conf" "/etc/${APPLICATION}/sites-enabled/"
    done

    sudo service $APPLICATION restart
}

restore_vhosts apache2
restore_vhosts nginx

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