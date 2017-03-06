#!/bin/sh

#install docker

mkdir -p /etc/systemd/system/docker.service.d

cat > /etc/systemd/system/docker.service.d/environment.conf <<"EOF"
[Service]
EnvironmentFile=/etc/default/docker
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// $DOCKER_OPTS
EOF

export DEBIAN_FRONTEND=noninteractive

apt-get update

apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     software-properties-common \
     gnupg2 \
     dirmngr \
     python-pip

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

add-apt-repository \
         "deb [arch=amd64] https://download.docker.com/linux/debian \
         $(lsb_release -cs) \
         stable"
apt-get update

apt-get install -y docker-ce

pip install docker-compose

adduser vagrant docker

perl -pi -e 's,GRUB_CMDLINE_LINUX="(.*)"$,GRUB_CMDLINE_LINUX="$1 apparmor=1 security=apparmor",' /etc/default/grub
update-grub
echo "DOCKER_OPTS=\"--storage-driver=overlay\"" >> /etc/default/docker
