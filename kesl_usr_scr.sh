#!/bin/bash
#не забыть снять решетку с /etc/hosts
set -e
sudo dpkg -i ./klnagent64_15.1.0-20748_amd64.deb
sleep 10

sudo /opt/kaspersky/klnagent64/lib/bin/setup/postinstall.pl
#y
#192.168.0.17
#
#
#y
#1
sleep 5

sudo dpkg -i ./kesl_12.1.0-1508_amd64.deb
sleep 5

sudo /opt/kaspersky/kesl/bin/kesl-setup.pl
#n
#
#
#
#q
#y
#y
#n
sudo apt install lshw

#
#
#