#!/bin/sh

#prepare sid installation
export DEBIAN_FRONTEND=noninteractive
sed -i 's/jessie/testing/g' /etc/apt/sources.list
echo "deb-src http://httpredir.debian.org/debian sid main contrib" >> /etc/apt/sources.list
echo "deb http://httpredir.debian.org/debian sid main contrib" >> /etc/apt/sources.list
apt-get update
apt-get upgrade -yf
apt-get dist-upgrade -yf  && apt-get dist-upgrade -yf
sed -e '/testing/d' -i /etc/apt/sources.list

#remove old linux kernel
#apt-get remove -yf linux-image-3.16.0-4-amd64
