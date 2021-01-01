#!/usr/bin/env bash

yum -y install libselinux
#sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=enforcing/g' /etc/selinux/config
sed -i --follow-symlinks 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config

# CIS 1.6.1.3 Ensure SELinux policy is configured
# This requires SE Linux parameter set. and that libselinux is not installed.
echo
echo "Ensure SELinux is installed"

#rpm -q libselinux || yum -y install libselinux