#!/bin/bash

ARCHIVE="/vagrant/joomla-box-backup.tar"
TEMP_DIR="/tmp/restore"

if [ -f "/home/vagrant/.restored-archive" ]; then
    exit 0
fi

if [ ! -f $ARCHIVE ]; then
    exit 0
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
  FILENAME=$(basename "$VHOST")
  SITENAME="${FILENAME/vhost-1-/}"
  SITENAME="${SITENAME/.conf.gz/}"

  gunzip $VHOST
  VHOST="${VHOST/.gz/}"

  # Make sure VirtualHosts are listening on port 8080 instead of 80
  # (we changed the port since adding Varnish support)
  if grep -Fxq "<VirtualHost *:80>" $VHOST
  then
      sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/g' $VHOST
  fi

  sudo mv $VHOST "/etc/apache2/sites-available/" || { echo "Failed to install $SITENAME! Aborting." 1>&2; exit 1; }
  sudo a2ensite "1-$SITENAME" || { echo "Failed to enable $SITENAME! Aborting." 1>&2; exit 1; }
done

echo "Restarting Apache .."
echo ""
sudo service apache2 restart
echo ""

echo "Restoring databases:"

for DB in $TEMP_DIR/mysql-*.sql.gz; do
  FILENAME=$(basename $DB)
  DBNAME=${FILENAME%.*}
  DBNAME="${DBNAME/.sql.gz/}"

  echo " * $DBNAME"

  gunzip $DB
  DB="${DB/.gz/}"

  mysql -uroot -proot < $DB || { echo "Failed to import database $DBNAME! Aborting." 1>&2; exit 1; }
done

echo "Cleaning up"
rm -rf $TEMP_DIR
echo $(date +%Y-%m-%d:%H:%M:%S) > "/home/vagrant/.restored-archive"

echo "Removing backup archive"
rm -f $ARCHIVE