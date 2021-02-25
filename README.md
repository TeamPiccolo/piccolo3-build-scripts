Build Scripts for piccolo3 system
#################################

build-pi.sh
===========
After you have installed a basic raspbian system using the [Raspberry Pi OS Lite](git@github.com:TeamPiccolo/piccolo3-build-scripts.git) image copy the build-pi.sh onto the piccolo system. At the top of the script you can set the name of the piccolo and the debian package for the piccolo system.

Once you are happy run the script with root privileges on the pi, ie
```
sudo ./build-pi.sh
```
The script will ask you to enter a new password for the pi user. It will install all required packages and setup the piccolo server. It will only start the piccolo server and web application.

gps-time.sh
===========
Run this script with root privileges on the piccolo to enable setting the system time from a GPS source. The script assumes that the GPS is attached to the internal serial port of the pi via GPIO pins. Once you have run the script and rebooted the system you can check the status of the GPS using
```
gpsmon
```
and the time sources used by the system using
```
chronyc sources -v
```
You can also get some more info by running
```
sudo chronyc tracking.
```
See also this [blog post](https://photobyte.org/raspberry-pi-stretch-gps-dongle-as-a-time-source-with-chrony-timedatectl/) for some background.

build-kiosk.sh
==============
Run this script with root pivileges to display the piccolo3-web using a browser to a local screen. The script assumes that the piccolo web app is running on the same pi. You might need to adjust the settings for the HDMI screen at the end of the file.
