#!/bin/bash -l

set -e

export PATH=$PATH:/home/vagrant/.gem/ruby/2.5.0/bin/

sudo gem install bundler --no-ri --no-rdoc

cd /tmp/tests

sudo chown vagrant:www-data /var/www
sudo chmod a=rx,ug+w /var/www

bundle install
BACKEND=exec bundle exec rake spec
