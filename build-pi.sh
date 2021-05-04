#!/bin/bash

# the name of the piccolo system
PICCOLONAME=piccolo3-test
# change to true to enable the triggered and/or reboot daemons
ENABLE_TRIGGERED_DAEMON=false
ENABLE_REBOOT_DAEMON=false

echo Enter new password
passwd pi

# set hostname
echo $PICCOLONAME > /etc/hostname
cat << EOF > /etc/hosts
127.0.0.1	localhost
127.0.0.1       $PICCOLONAME

# The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

# setup ssh
systemctl enable ssh
systemctl start ssh

# install piccolo repo key
wget -O /tmp/GeoSciences-Package-Service.gpg https://debs.geos.ed.ac.uk/keys/GeoSciences-Package-Service.gpg
apt-key add /tmp/GeoSciences-Package-Service.gpg

# and add repo
cat <<EOF > /etc/apt/sources.list.d/piccolo.sources
Types: deb
URIs: https://debs.geos.ed.ac.uk/piccolo
Suites:  buster
Components: piccolo
Signed-By: 7859D35F0CD88A9E939AE644CB330CFDB2D2256F
EOF

# update system and install dependencies
apt -y update
apt -y dist-upgrade
apt -y install chrony
apt -y install geos-release-ubuntu piccolo3-server-bundle

# setup piccolo server
cat << EOF > /etc/piccolo.cfg
[coap]
address = ::
port = 5683
[daemon]
daemon = False
[datadir]
mount = True
datadir = piccolo3_data
device = /dev/sda1
EOF

# set timezone to UTC
timedatectl set-timezone UTC

# start piccolo services
systemctl enable piccolo3-server piccolo3-web

if [ "$ENABLE_TRIGGERED_DAEMON" = true ]; then
    systemctl enable piccolo3-triggered
fi
if [ "$ENABLE_REBOOT_DAEMON" = true ]; then
    systemctl enable piccolo3-reboot
fi

reboot
