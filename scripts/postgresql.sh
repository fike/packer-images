#!/bin/sh

#prepare postgresql installation
export DEBIAN_FRONTEND=noninteractive
echo "deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main" >> /etc/apt/sources.list.d/postgresql.list
apt-get install  -y ca-certificates
curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
apt-get update
apt-get upgrade
apt-get install -y postgresql-9.6 postgresql-contrib-9.6
