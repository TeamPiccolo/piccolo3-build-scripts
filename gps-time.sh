#!/bin/bash

# enable GPS time source attached via built in serial port

# serial device
SERIAL=/dev/serial0

# enable UART
echo enable_uart=1 > /boot/config.txt
# disable serial console
systemctl stop serial-getty@ttyS0.service
systemctl disable serial-getty@ttyS0.service
# do not start a console on the serial line
sed -i 's|console=serial[^ ]* ||' /boot/cmdline.txt

# install software
apt install -y gpsd gpsd-clients chrony

# setup gpsd
cat << EOF > /etc/default/gpsd
START_DAEMON="true"
USBAUTO="false"
DEVICES="$SERIAL"
GPSD_OPTIONS="-n"
EOF

# configure chrony
echo "refclock SHM 0 offset 0.5 delay 0.2 refid NMEA" >> /etc/chrony/chrony.conf

