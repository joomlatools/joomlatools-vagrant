#!/usr/bin/env bash
# Based on https://rshestakov.wordpress.com/2014/02/02/how-to-manage-public-and-private-puppet-modules-with-vagrant/

export PATH=$PATH:/opt/puppetlabs/bin/

# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR=/vagrant/puppet/

# NB: librarian-puppet might need git and gem installed. If it is not already installed
# in your base box, this will manually install it at this point using apt or yum
$(which git > /dev/null 2>&1)
FOUND_GIT=$?
if [ "$FOUND_GIT" -ne '0' ]; then
  echo 'Attempting to install git.'

  apt-get -q -y update
  apt-get -q -y install git
  echo 'git installed.'
fi

$(which gem > /dev/null 2>&1)
FOUND_GEM=$?
if [ "$FOUND_GEM" -ne '0' ]; then
  echo 'Attempting to install ruby.'

  apt-get -q -y update
  apt-get -q -y install ruby ruby-json
  echo 'ruby installed.'
fi

# Now install the Puppet modules
if [ "$(gem search -i librarian-puppet)" = "false" ]; then
  gem install librarian-puppet -v 2.2.3 --no-ri --no-rdoc
  cd $PUPPET_DIR && librarian-puppet install --path modules/
else
  cd $PUPPET_DIR && librarian-puppet update
fi