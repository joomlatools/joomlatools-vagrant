#!/usr/bin/env bash
# Based on https://rshestakov.wordpress.com/2014/02/02/how-to-manage-public-and-private-puppet-modules-with-vagrant/

# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR=/vagrant/puppet/

# NB: librarian-puppet might need git installed. If it is not already installed
# in your base box, this will manually install it at this point using apt
 $(which git > /dev/null 2>&1)
FOUND_GIT=$?
if [ "$FOUND_GIT" -ne '0' ]; then
  echo 'Attempting to install git.'

  apt-get -q -y update
  apt-get -q -y install git
  echo 'git installed.'
fi

# Now install the Puppet modules
if [ "$(gem search -i librarian-puppet)" = "false" ]; then
  apt-get -q -y install ruby-json ruby1.9.1-dev build-essential
  gem install librarian-puppet
  cd $PUPPET_DIR && librarian-puppet install --path modules/common/
else
  cd $PUPPET_DIR && librarian-puppet update
fi
