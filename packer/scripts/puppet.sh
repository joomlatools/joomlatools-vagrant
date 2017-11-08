#!/bin/bash

set -e

apt-get install -y software-properties-common python-software-properties

cd /tmp
wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb
dpkg -i puppetlabs-release-trusty.deb

apt-get update
apt-get install -y puppet-common
