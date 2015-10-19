#!/bin/bash

ARCHIVE="/vagrant/joomla-box-backup.tar"
TEMP_DIR="/tmp/restore"

RED='\033[0;31m' # Red color
NC='\033[0m' # No Color

if [ -f "/home/vagrant/.restored-archive" ]; then
    exit 0
fi

if [ ! -f $ARCHIVE ]; then
    exit 0
fi

mkdir -p $TEMP_DIR
tar -xf $ARCHIVE -C $TEMP_DIR

ls -lah $TEMP_DIR

echo "Restoring virtual hosts:"
for VHOST in "$TEMP_DIR/vhost-1-*.conf.gz"; do
  FILENAME=$(basename $VHOST)
  SITENAME=${FILENAME%.*}
  SITENAME=${SITENAME:2}

  echo " * $SITENAME"

  gunzip $VHOST

  # Make sure VirtualHosts are listening on port 8080 instead of 80
  # (we changed the port since adding Varnish support)
  if grep -Fxq "<VirtualHost *:80>" $VHOST
  then
      sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/g' $VHOST
  fi

  sudo mv $VHOST "/etc/apache2/sites-available/" || { echo "${RED}Failed to install $SITENAME! Aborting.${NC}" ; exit 1; }
  sudo a2ensite $SITENAME || { echo "${RED}Failed to enabled $SITENAME! Aborting.${NC}" ; exit 1; }
done

echo "Restarting Apache .."
sudo service apache2 restart

echo "Restoring databases:"

for DB in "$TEMP_DIR/mysql-*.sql.gz"; do
  FILENAME=$(basename $DB)
  DBNAME=${FILENAME%.*}

  echo " * $DBNAME"

  gunzip $DB
  mysql -uroot -proot < $DB || { echo "${RED}Failed to import database $DBNAME! Aborting.${NC}" ; exit 1; }
done

echo "Cleaning up"

rm -rf $TEMP_DIR
echo $(date +%Y-%m-%d:%H:%M:%S) > "/home/vagrant/.restored-archive"