#!/bin/sh

apt-get update
apt-get install -t jessie-backports -y \
  linux-base \
  firmware-linux-free \
  linux-image-4.9.0-0.bpo.2-amd64 \
  linux-headers-4.9.0-0.bpo.2-amd64 \
  irqbalance \
  systemd \
  libseccomp2 \
  apparmor \
  apparmor-profiles \
  apparmor-utils \
