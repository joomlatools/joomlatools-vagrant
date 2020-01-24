#!/bin/bash

set -e

apt-get install -y software-properties-common

cd /tmp
wget https://apt.puppetlabs.com/puppet5-release-bionic.deb
dpkg -i puppet5-release-bionic.deb

apt-get update
apt-get install -y puppet

# Disable Puppet Agent
systemctl disable puppet
