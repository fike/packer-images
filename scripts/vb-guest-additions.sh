#!/bin/sh
echo "installing virtualbox guest additions"

# install virtualbox additions build dependancies
apt-get install --yes --no-install-recommends linux-headers-amd64 dkms bzip2

# Install the VirtualBox guest additions
DEBIAN_VERSION=$(cat /etc/debian_version|cut -c 1)
if [ $DEBIAN_VERSION -eq 8 ]
then
  VBOX_VERSION=$(cat /home/vagrant/.vbox_version)
  VBOX_ISO=VBoxGuestAdditions_$VBOX_VERSION.iso
  curl -L -O  http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso
  mount -o loop $VBOX_ISO /mnt
  yes|sh /mnt/VBoxLinuxAdditions.run
  umount /mnt
  rm $VBOX_ISO
  /opt/VBoxGuestAdditions-5.1.14/routines.sh
  systemctl daemon-reload
  systemctl restart vboxadd.service
else
  apt-get install --yes --no-install-recommends virtualbox-guest-dkms
fi
