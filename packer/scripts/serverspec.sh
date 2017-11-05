#!/bin/bash

set -e

if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  source "$HOME/.rvm/scripts/rvm"
else
  echo "ERROR: An RVM installation was not found for user $USER"
  exit 1
fi

gem install bundler --no-ri --no-rdoc

cd /tmp/tests

sudo chown vagrant:vagrant /var/www

bundle install
BACKEND=exec bundle exec rake spec