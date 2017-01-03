#!/bin/sh
# Set up Vagrant.
# Based debian packer to build vagrant images.

set -e

date > /etc/vagrant_box_build_time

# Installing vagrant keys
mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cd /home/vagrant/.ssh
curl -Lo /home/vagrant/.ssh/authorized_keys \
  'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub'
chmod 600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh

# Set up sudo
echo "%vagrant ALL=NOPASSWD:ALL" > /etc/sudoers.d/vagrant
chmod 0440 /etc/sudoers.d/vagrant

# Setup sudo to allow no-password sudo for "sudo"
adduser vagrant sudo

# Customize the message of the day
echo 'Welcome to your Vagrant-built virtual machine.' > /var/run/motd
