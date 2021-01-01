#!/usr/bin/env bash
#set -x

# Disable core dumps
echo "* hard core 0" >> /etc/security/limits.conf
# Limit the Number of Concurrent Login Sessions Allowed Per User
echo "* hard maxlogins 10" >> /etc/security/limits.conf
