sudo apt-get install -y python-software-properties

cd /tmp
wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
sudo dpkg -i puppetlabs-release-precise.deb

apt-get update
apt-get install -y puppet-common
