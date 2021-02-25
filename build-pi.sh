#!/bin/bash

# the name of the piccolo system
PICCOLONAME=piccolo3-test
# the piccolo server package
PICCOLOPKG=piccolo3-server-bundle_0.2-4_armhf.deb

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

# update system and install dependencies
apt -y update
apt -y dist-upgrade
apt -y install python3-numpy python3-psutil python3-configobj python3-daemon \
    python3-tz python3-gpiozero python3-dateutil python3-lockfile \
    python3-bitarray python3-scipy python3-sqlalchemy python python3-usb

# get server bundle
wget www.geos.ed.ac.uk/~mhagdorn/piccolo/$PICCOLOPKG

dpkg -i $PICCOLOPKG

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

# start piccolo services
systemctl enable piccolo3-server piccolo3-web

reboot
