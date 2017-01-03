#!/bin/sh
echo "installing virtualbox guest additions"

# install virtualbox additions build dependancies
apt-get update
apt-get install --yes --no-install-recommends linux-headers-amd64 dkms bzip2

# Install the VirtualBox guest additions
DEBIAN_VERSION=$(cat /etc/debian_version|cut -c 1)
if [ $DEBIAN_VERSION -eq 8 ]
then
  apt-get install -t jessie-backports --yes --no-install-recommends virtualbox-guest-dkms
else
  apt-get install --yes --no-install-recommends virtualbox-guest-dkms
fi
