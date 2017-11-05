#!/bin/bash

# Mount the disk image
cd /tmp
mkdir /tmp/isomount
mount -t iso9660 -o loop /home/vagrant/VBoxGuestAdditions.iso /tmp/isomount

# Install the drivers
/tmp/isomount/VBoxLinuxAdditions.run

# Cleanup
umount /tmp/isomount
rm -rf /tmp/isomount /home/vagrant/VBoxGuestAdditions.iso