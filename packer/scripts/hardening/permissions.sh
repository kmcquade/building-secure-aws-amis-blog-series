#!/bin/sh

# Ensure permissions on /etc/passwd are configured
echo
echo "Ensure permissions on /etc/passwd are configured"
chmod -t,u+r+w-x-s,g+r-w-x-s,o+r-w-x /etc/passwd

# Ensure permissions on /etc/shadow are configured
echo
echo "Ensure permissions on /etc/shadow are configured"
chmod -t,u-x-s,g-w-x-s,o-r-w-x /etc/shadow

# Ensure permissions on /etc/group are configured
echo
echo "Ensure permissions on /etc/group are configured"
chmod -t,u+r+w-x-s,g+r-w-x-s,o+r-w-x /etc/group

# Ensure permissions on /etc/gshadow are configured
echo
echo "Ensure permissions on /etc/gshadow are configured"
chmod -t,u-x-s,g-w-x-s,o-r-w-x /etc/gshadow

# Ensure permissions on /etc/passwd- are configured
echo
echo "Ensure permissions on /etc/passwd- are configured"
#chmod -t,u-x-s,g-r-w-x-s,o-r-w-x /etc/passwd-

# Ensure permissions on /etc/shadow- are configured
echo
echo "Ensure permissions on /etc/shadow- are configured"
chmod -t,u-x-s,g-r-w-x-s,o-r-w-x /etc/shadow-

# Ensure permissions on /etc/group- are configured
echo
echo "Ensure permissions on /etc/group- are configured"
chmod -t,u-x-s,g-r-w-x-s,o-r-w-x /etc/group-

# Ensure permissions on /etc/gshadow- are configured
echo
echo "Ensure permissions on /etc/gshadow- are configured"
chmod -t,u-x-s,g-r-w-x-s,o-r-w-x /etc/gshadow-

find /var/log -type f -exec chmod g-wx,o-rwx {} +

chmod 600 /var/log/dmesg
chmod 600 /var/log/wtmp

# (1.35) 9340 Permissions set on the file /boot/grub2/grub.cfg
chmod 600 /boot/grub2/grub.cfg

#### systemd override procedure to fix dmesg permissions
#### https://access.redhat.com/discussions/3212301

#
# Any service file in /etc/systemd/system whose name will exactly match a file in /usr/lib/systemd/system will override /usr/lib/systemd/system version of the file. This is the standard way to customize systemd services in a way that is guaranteed not to be overwritten with RPM updates.
#cp /usr/lib/systemd/system/rhel-dmesg.service /etc/systemd/system/rhel-dmesg.service

# Point to Customized version of script - /etc/systemd/rhel-dmesg is new

# New script below, then new rhel-dmesg.service below that

cat <<EOF > /etc/systemd/rhel-dmesg
#!/bin/bash
umask 0077  # added for hardening
[ -f /var/log/dmesg ] && mv -f /var/log/dmesg /var/log/dmesg.old
dmesg -s 131072 > /var/log/dmesg
EOF

chmod 600 /etc/systemd/rhel-dmesg
chmod +x /etc/systemd/rhel-dmesg

cat <<EOF > /etc/systemd/system/rhel-dmesg.service
[Unit]
Description=Dump dmesg to /var/log/dmesg
After=basic.target
ConditionVirtualization=!container

[Service]
Type=oneshot
User=root
ExecStart=/etc/systemd/rhel-dmesg
RemainAfterExit=yes

[Install]
WantedBy=basic.target

EOF

# for WTMP:
# For wtmp, the default permissions are defined in /usr/lib/tmpfiles.d/var.conf: since this is also a systemd component (see man systemd-tmpfiles), I recommend copying /usr/lib/tmpfiles.d/var.conf to /etc/tmpfiles.d/ and modifying the copy to override the default permissions. However, I have not tested this.

# Originally at /usr/lib/tmpfiles.d/var.conf

cat <<EOF > /etc/tmpfiles.d/var.conf
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

# See tmpfiles.d(5) for details

d /var 0755 - - -

L /var/run - - - - ../run

d /var/log 0600 - - -
f /var/log/wtmp 0600 root utmp -
f /var/log/btmp 0600 root utmp -

d /var/cache 0755 - - -

d /var/lib 0755 - - -
v /var/lib/machines 0700 - - -

d /var/spool 0755 - - -
EOF

#
#chmod 755 /etc/rc.d/init.d/log-permissions

cat <<EOF > /etc/init.d/fix-permissions
#!/bin/bash
#
# fix-permissions          Set permissions on /var/log, grub, and cron files.
#
# chkconfig: 2345 90 60
# description: Set permissions to 600 on grub, dmesg, wtmp, and  \
#              the entire /var/log directory.

chmod 600 /boot/grub2/grub.cfg
chmod 600 /var/log/dmesg
chmod 600 /var/log/wtmp
chmod 600 /etc/cron.d/
chmod 600 /etc/cron.weekly/
chmod 600 /etc/cron.daily/
chmod 600 /etc/cron.hourly/
chmod 600 /etc/cron.monthly/
chmod 600 /etc/crontab
find /var/log -type f -exec chmod g-wx,o-rwx {} +
EOF

chmod 755 /etc/init.d/fix-permissions

chkconfig --add fix-permissions

service fix-permissions stop
service fix-permissions start