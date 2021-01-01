#!/bin/sh

# Borrowed from: https://github.com/fcaviggia/hardened-centos7-kickstart/blob/master/config/hardening/supplemental.sh

# This script was written by Frank Caviggia
# Last update was 13 May 2017
#
# Script: supplemental.sh (system-hardening)
# Description: Supplemental Hardening
# License: Apache License, Version 2.0
# Copyright: Frank Caviggia, 2018
# Author: Frank Caviggia <fcaviggi (at) gmail.com>


########################################
# Fix cron.allow
########################################
echo "root" > /etc/cron.allow
chmod 400 /etc/cron.allow
chown root:root /etc/cron.allow


########################################
# Make SELinux Configuration Immutable
########################################
chattr +i /etc/selinux/config


########################################
# Disable Control-Alt-Delete
########################################
ln -sf /dev/null /etc/systemd/system/ctrl-alt-del.target


########################################
# No Root Login to Console (use admin user)
########################################
cat /dev/null > /etc/securetty


########################################
# SSSD Configuration
########################################
mkdir -p /etc/sssd
cat <<EOF > /etc/sssd/sssd.conf
[sssd]
services = sudo, autofs, pam
EOF

########################################
# Disable Interactive Shell (Timeout)
########################################
echo "TMOUT=600" >> /etc/profile
echo "TMOUT=600" >> /etc/bashrc

cat <<EOF > /etc/profile.d/autologout.sh
#!/bin/sh
TMOUT=600
export TMOUT
#readonly TMOUT
EOF
cat <<EOF > /etc/profile.d/autologout.csh
#!/bin/csh
set autologout=15
set -r autologout
EOF
chown root:root /etc/profile.d/autologout.sh
chown root:root /etc/profile.d/autologout.csh
chmod 555 /etc/profile.d/autologout.sh
chmod 555 /etc/profile.d/autologout.csh

########################################
# Set Shell UMASK Setting (027)
########################################
cat <<EOF > /etc/profile.d/umask.sh
#!/bin/sh
# Non-Privileged Users get 027
# Privileged Users get 022
if [[ \$EUID -ne 0 ]]; then
	umask 027
else
	umask 022
fi
EOF
cat <<EOF > /etc/profile.d/umask.csh
#!/bin/csh
umask 027
EOF
chown root:root /etc/profile.d/umask.sh
chown root:root /etc/profile.d/umask.csh
chmod 555 /etc/profile.d/umask.sh
chmod 555 /etc/profile.d/umask.csh


########################################
# Vlock Alias (Cosole Screen Lock)
########################################
cat <<EOF > /etc/profile.d/vlock-alias.sh
#!/bin/sh
alias vlock='clear;vlock -a'
EOF
cat <<EOF > /etc/profile.d/vlock-alias.csh
#!/bin/csh
alias vlock 'clear;vlock -a'
EOF
chown root:root /etc/profile.d/vlock-alias.sh
chown root:root /etc/profile.d/vlock-alias.csh
chmod 555 /etc/profile.d/vlock-alias.sh
chmod 555 /etc/profile.d/vlock-alias.csh


########################################
# Wheel Group Require (sudo)
########################################
sed -i -re '/pam_wheel.so use_uid/s/^#//' /etc/pam.d/su
sed -i 's/^#\s*\(%wheel\s*ALL=(ALL)\s*ALL\)/\1/' /etc/sudoers
echo -e "\n## Set timeout for authentiation (5 Minutes)\nDefaults:ALL timestamp_timeout=5\n" >> /etc/sudoers



########################################
# Disable SystemD Date Service
# Use (chrony or ntpd)
########################################
timedatectl set-ntp false

########################################
# Disable Kernel Dump Service
########################################
systemctl disable kdump.service
systemctl mask kdump.service


########################################
# Just to lower the scan count
# Disable Kernel Dump Service
########################################

if grep --silent "^install usb-storage" /etc/modprobe.d/usb-storage.conf ; then
        sed -i 's/^install usb-storage.*/install usb-storage /bin/true/g' /etc/modprobe.d/usb-storage.conf
else
        echo -e "\n# Disable per security requirements" >> /etc/modprobe.d/usb-storage.conf
        echo "install usb-storage /bin/true" >> /etc/modprobe.d/usb-storage.conf
fi

# Ensure permissions on /etc/passwd- are configured
# The '/etc/passwd-' file contains backup user account information. The directory should be protected from unauthorized users hence, permissions of the file should be restricted and should be configured according to the needs of the business.

chmod -t,u-x-s,g-r-w-x-s,o-r-w-x /etc/passwd-

# Status of the network parameter 'fs.suid_dumpable' setting within '/etc/sysctl.conf' file

echo "fs.suid_dumpable = 0" >> /etc/sysctl.conf

# Ensure permissions on all logfiles are configured
#chmod -R g-w-x,o-r-w-x /var/log/.*

# Per the CIS report
find /var/log -type f -exec chmod g-wx,o-rwx {} +

# CIS 2.2.2 Ensure X Window System is not installed

yum -y remove xorg-x11*
#yum -y xorg-x11-fonts-Type1 xorg-x11-font-utils