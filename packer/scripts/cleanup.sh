echo "cleaning up apt"
apt-get -y autoremove
apt-get -y clean
apt-get -y autoclean all
rm -rf /var/lib/apt/lists/*

echo "cleaning up guest additions"
rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?

echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

echo "cleaning up udev rules"
rm /etc/udev/rules.d/70-persistent-net.rules
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

echo "removing unneeded source files"
rm -rf /usr/src/*

echo "remove documentation"
rm -rf /usr/share/doc/* /usr/share/lintian/* /usr/share/linda/* /var/cache/man/*